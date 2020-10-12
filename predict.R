library(randomForest)

get_predictions <- function(request_data) {
    model.rf <- load_model()
    ## NOTE level setting in rf for unkown values not done
    predictions<-predict(model.rf,newdata=request_data$instances)
    return (predictions)
}


load_model <- function() {
    ## NOTE Model does not neccessarily live inside /opt/ml/model/ except for sagemaker (see: https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-inference-code.html#your-algorithms-inference-code-container-response)
    prefix <- '/opt/ml'
    model_filename <- list.files(paste(prefix, 'model', sep='/'))[1]
    model_filepath <- paste(prefix, 'model', model_filename, sep='/')

    model.rf <- readRDS(model_filepath)

    return (model.rf)
}
