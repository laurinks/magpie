# |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

source("scripts/start_functions.R")


performance_start <- function(cfg="default.cfg",modulepath="modules/",id="performance",sequential=NA) {
  require(lucode2)

  if(!is.list(cfg)) {
    if(is.character(cfg)) {
      source(file.path("config",cfg),local=TRUE)
      if(!is.list(cfg)) stop("Wrong input file format: config file does not contain a cfg list!")
    } else {
      stop("Wrong input format: cfg is neither a list nor a character!")
    }
  }

  cfg$results_folder <- "output/:title:"

  cfg$sequential <- sequential
  cfg$logoption <- 2

  git <- try(system("git rev-parse HEAD",intern=TRUE), silent=TRUE)
  save(git,file="git.rda")
  cfg$files2export$start <- c(cfg$files2export$start,"git.rda")

  #start default run
  cfg$title <- paste(id,"default",sep="__")
  cat(cfg$title,"\n")
  try(start_run(cfg))

  m <- getModules(modulepath)
  for(i in 1:dim(m)[1]) {
    default <- cfg$gms[[m[i,"name"]]]
    r <- strsplit(m[i,"realizations"],",")[[1]]
    r <- r[r!=default]  #remove default case
    for(j in r) {
      cfg$gms[[m[i,"name"]]] <- j
      cfg$title <- paste(id,m[i,"name"],j,sep="__")
      cat(cfg$title,"\n")
      try(start_run(cfg, codeCheck=FALSE))
    }
    cfg$gms[[m[i,"name"]]] <- default
  }
}

performance_collect <- function(id="performance",results_folder="output/",plot=TRUE) {
  require(magpie4)
  require(lucode2)
  withr::local_dir(results_folder)
  folders <- grep(paste("^",id,"__",sep=""),list.dirs(full.names = FALSE, recursive = FALSE),value=TRUE)
  tmp <- grep(paste("^",id,"__default",sep=""),folders)
  default <- folders[tmp]
  if(length(default)==0) stop("No default folder found which fits to the given id (",id,")")
  folders <- folders[-tmp]
  if(length(folders)==0) stop("No folders found which fit to the given id (",id,")")

  .modelstats <- function(f,colMeans=TRUE) {
    logfile <- file.path(f,"full.log")
    if(file.exists(logfile)) {
      tmp <- readLines(logfile)
      p1 <- "---   ([^ ]*) rows  ([^ ]*) columns  ([^ ]*) non-zeroes"
      p2 <- "---   ([^ ]*) nl-code  ([^ ]*) nl-non-zeroes"
      l1 <- grep(p1,tmp,value=TRUE)
      l2 <- grep(p2,tmp,value=TRUE)

      if(length(l1)==0 & length(l2)==0) return(NA)

      rows <- max(as.integer(gsub(",","",gsub(p1,"\\1",l1))))
      columns <- max(as.integer(gsub(",","",gsub(p1,"\\2",l1))))
      nonzeroes <- max(as.integer(gsub(",","",gsub(p1,"\\3",l1))))

      nlcode <- max(as.integer(gsub(",","",gsub(p2,"\\1",l2))))
      nlnonzeroes <- max(as.integer(gsub(",","",gsub(p2,"\\2",l2))))
    } else {
      rows <- columns <- nonzeroes <- nlcode <- nlnonzeroes <- NA
    }
    out <- cbind(rows,columns,nonzeroes,nlcode,nlnonzeroes)
    rownames(out) <- paste("max",1:dim(out)[1],sep="")
    if(colMeans) out <- colMeans(out)
    return(out)
  }

  .infescheck <- function(gdx) {
    if(!file.exists(gdx)) return(3)
    tmp <- modelstat(gdx)
    if(any(tmp!=2 & tmp!=7)) {
      x <- 2
    } else if(any(tmp!=2 & tmp==7)) {
      x <- 1
    } else {
      x <- 0
    }
    return(x)
  }

  .gettime <- function(rdata) {
    load(rdata)
    tmp <- as.double(validation$technical$time$magpie.gms,unit="mins")
    return(ifelse(length(tmp)==0,NA,tmp))
  }

  results <- NULL
  infes <- list()
  for(f in folders){
    tmp <- strsplit(f,"__")[[1]]
    ms <- .modelstats(f,colMeans=TRUE)
    tmp2 <- data.frame(module=tmp[2],realization=tmp[3],default=FALSE,runtime=.gettime(file.path(f,paste0(f,".RData"))),infes=.infescheck(file.path(f,"fulldata.gdx")),
                       rows=ms["rows"],columns=ms["columns"],nonzeroes=ms["nonzeroes"],nlcode=ms["nlcode"],nlnonzeroes=ms["nlnonzeroes"])
    results <- rbind(results,tmp2)
  }
  cfg <- gms::loadConfig(file.path(default, "config.yml"))
  for(n in unique(results$module)) {
    ms <- .modelstats(default,colMeans=TRUE)
    tmp <- data.frame(module=n,realization=cfg$gms[[n]],default=TRUE,runtime=.gettime(file.path(default,paste0(default,".RData"))),infes=.infescheck(file.path(default,"fulldata.gdx")),
                      rows=ms["rows"],columns=ms["columns"],nonzeroes=ms["nonzeroes"],nlcode=ms["nlcode"],nlnonzeroes=ms["nlnonzeroes"])
    results <- rbind(results,tmp)
  }
  results$info <- paste(results$module,results$realization,sep=": ")
  results$relative_runtime <- results$runtime/results[results$default,"runtime"][1] - 1
  results$more_info[results$default] <- "default"
  results$more_info[results$infes==0 & !results$default] <- paste(round(results$relative_runtime[results$infes==0 & !results$default]*100),"%",sep="")
  results$more_info[results$infes==1] <- "non-optimal solution"
  results$more_info[results$infes==2] <- "infeasible solution"
  results$more_info[results$infes==3] <- "compilation error"
  results$relative_rows <- results$rows/results[results$default,"rows"][1] - 1
  results$relative_columns <- results$columns/results[results$default,"columns"][1] - 1
  results$relative_nonzeroes <- results$nonzeroes/results[results$default,"nonzeroes"][1] - 1
  results$relative_nlcode <- results$nlcode/results[results$default,"nlcode"][1] - 1
  results$relative_nlnonzeroes <- results$nlnonzeroes/results[results$default,"nlnonzeroes"][1] - 1
  attr(results,"default_cfg") <- cfg
  attr(results,"id") <- id

  if(file.exists(file.path(default,"git.rda"))) {
    load(file.path(default,"git.rda"))
    attr(results,"git") <- git
  }

  setwd(maindir)
  if(plot) performance_plot(results)
  return(results)
}


performance_plot <- function(x) {
  require(ggplot2)
  require(lusweave)

  .create_plot <- function(x,weight="relative_runtime",label="runtime/default_runtime2") {
    p <- ggplot(x, aes_string(x="info",weight=weight,fill="module")) + geom_bar(position="dodge")+coord_flip()+labs(y=label,x="",size=2)
    p <- p +  geom_text(aes(y=0,label=more_info), hjust=0, size = 3) + theme(legend.position="none")
    print(p)
  }

  .tmptable <- function(sw,tmp) {
    nrow <- ceiling(length(tmp)/2)
    if(nrow*2 > length(tmp)) tmp <- c(tmp,"")
    swtable(sw,matrix(tmp,nrow),align="l",include.colnames=FALSE,include.rownames=FALSE,vert.lines=0,hor.lines=0)
    return(sw)
  }

  sw_option <- "width=11,height=12"

  sw <- swopen(paste("performance_check_",attr(x,"id"),".pdf",sep=""))
  swlatex(sw,c("\\title{Performance test results}","\\author{Model Operations Group}","\\maketitle","\\tableofcontents"))

  swlatex(sw,"\\newpage")

  swlatex(sw,"\\section{General information}")
  swlatex(sw,"\\subsection{Settings default run}")

  sw <- .tmptable(sw,x$info[x$default])

  swlatex(sw,"\\subsection{Run information default run}")
  tmp <- x[x$default,][1,c("runtime","rows","columns","nonzeroes","nlcode","nlnonzeroes")]
  tmp2 <- cbind(format(round(as.vector(as.matrix(tmp)),0),nsmall=0),names(tmp))
  rownames(tmp2) <- names(tmp)
  colnames(tmp2) <- c("data","description")
  tmp2[,"description"] <- c(" minutes (total runtime)",
                            " (max of all optimizations)",
                            " (max of all optimizations)",
                            " (max of all optimizations)",
                            " (max of all optimizations)",
                            " (max of all optimizations)")

  swtable(sw,tmp2,align="r")


  swlatex(sw,"\\newpage")

  #remove default run from results
  x <- x[!x$default,]

  tmp <- x$info[x$more_info =="compilation error"]
  if(length(tmp)>0){
    swlatex(sw,"\\subsection{Compilation errors}")
    sw <- .tmptable(sw,tmp)
    #remove runs with compilation error from results
    x <- x[x$more_info!="compilation error",]
  }

  tmp <- x$info[x$more_info =="infeasible solution"]
  if(length(tmp)>0){
    swlatex(sw,"\\subsection{Infeasible solutions}")
    sw <- .tmptable(sw,tmp)
  }

  .tmp <- function(sw,x) {
    swlatex(sw,"\\subsection{relative runtime}")
    swfigure(sw,.create_plot,x,weight="relative_runtime",label="runtime relative to default run",sw_option=sw_option)
    swlatex(sw,"\\subsection{relative number of rows}")
    swfigure(sw,.create_plot,x,weight="relative_rows",label="No. of rows relative to default",sw_option=sw_option)
    swlatex(sw,"\\subsection{relative number of columns}")
    swfigure(sw,.create_plot,x,weight="relative_columns",label="No. of columns relative to default",sw_option=sw_option)
    swlatex(sw,"\\subsection{relative number of nonzeroes}")
    swfigure(sw,.create_plot,x,weight="relative_nonzeroes",label="No. of nonzeroes relative to default",sw_option=sw_option)
    swlatex(sw,"\\subsection{relative number of nl code}")
    swfigure(sw,.create_plot,x,weight="relative_nlcode",label="Lines of NL code relative to default",sw_option=sw_option)
    swlatex(sw,"\\subsection{relative number of nl nonzeroes}")
    swfigure(sw,.create_plot,x,weight="relative_nlnonzeroes",label="No. of NL nonzeroes relative to default",sw_option=sw_option)
    return(sw)
  }

  swlatex(sw,"\\section{Results sorted by module}")
  sw <- .tmp(sw,x)

  x <- x[order(x$runtime,decreasing=TRUE),]
  x$info <- factor(x$info,x$info)

  swlatex(sw,"\\section{Results sorted by runtime}")
  sw <- .tmp(sw,x)

  if(!is.null(attr(x,"git"))){
    swlatex(sw,"\\section{GIT info}")
    sw <- .tmptable(sw,c(attr(x,"git"),rep("",length(attr(x,"git")))))
  }

  swlatex(sw,"\\newpage\\section{Full default config}")
  tmp <- unlist(attr(x,"default_cfg"))
  n <- 35
  while(length(tmp)>n) {
    sw <- .tmptable(sw,c(names(tmp)[1:n],tmp[1:n]))
    tmp <- tmp[-(1:n)]
  }
  sw <- .tmptable(sw,c(names(tmp),tmp))



  swclose(sw)
}
