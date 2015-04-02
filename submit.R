if(!require(RWordPress)){
    install.packages("RWordPress", repos="http://www.omegahat.org/R")
}

require(knitr)
options(WordpressLogin = c(rain1024 = "240709010"),
        WordpressURL= "https://datayo.wordpress.com/xmlrpc.php")

knit2wp.com <- function(file) {
    require(XML)
    post.content <- readLines(file)
    post.content <- gsub(" <", "&nbsp;<", post.content)
    post.content <- gsub("> ", ">&nbsp;", post.content)
    post.content <- htmlTreeParse(post.content)
    post.content <- paste(capture.output(print(post.content$children$html$children$body, 
                                               indent = FALSE, tagSeparator = "")), collapse = "\n")
    post.content <- gsub("<?.body>", "", post.content)
    post.content <- gsub("<p>", "<p style=\"text-align: justify;\">", post.content)
    post.content <- gsub("<?pre><code class=\"r\">", "\\[sourcecode language=\"r\"\\]\\\n ", 
                         post.content)
    post.content <- gsub("<?pre><code class=\"no-highlight\">", "\\[sourcecode\\]\\\n ", 
                         post.content)
    post.content <- gsub("<?/code></pre>", "\\\n\\[/sourcecode\\]", post.content)
    return(post.content)
}

knit2html('reports//report.Rmd', out='reports//report.html')

CreateNewPost <- function(){
    newPost(
        list(
            description=knit2wp.com('reports/report.html'),
            title='Map Visualization with Leaflet package in R',
            categories=c('reserach'),
            mt_keywords=c('visualization')
        ),
        publish=TRUE)    
}
