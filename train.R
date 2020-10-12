#!/usr/local/bin/Rscript
# https://tensorflow.rstudio.com/tutorials/beginners/
# http://rischanlab.github.io/RandomForest.html
library(keras)
library(randomForest)

get_mnist_dataset <- function() {
    mnist <- dataset_mnist()
    mnist$train$x <- mnist$train$x/255
    mnist$test$x <- mnist$test$x/255
    return (mnist)
}

get_iris_data <- function() {
    ind <- sample(2,nrow(iris),replace=TRUE,prob=c(0.7,0.3))
    trainData <- iris[ind==1,]
    # testData <- iris[ind==2,]
    return (trainData)
}

get_mnist_model <- function() {
    model <- keras_model_sequential() %>% 
    layer_flatten(input_shape = c(28, 28)) %>% 
    layer_dense(units = 128, activation = "relu") %>% 
    layer_dropout(0.2) %>% 
    layer_dense(10, activation = "softmax")

    model %>% 
    compile(
        loss = "sparse_categorical_crossentropy",
        optimizer = "adam",
        metrics = "accuracy"
    )

    return (model)
}


train_mnist_model <- function(dataset, model) {
    model %>% 
    fit(
        x = dataset$train$x, y = dataset$train$y,
        epochs = 5,
        validation_split = 0.3,
        verbose = 2
    )

    return (model)
}

train_iris_model <- function(trainData) {
    iris_rf <- randomForest(Species~.,data=trainData,ntree=100,proximity=TRUE)
    return (iris_rf)
}


evaluate_mnist_model <- function(dataset, model) {
    predictions <- predict(model, dataset$test$x)

    model %>% 
    evaluate(dataset$test$x, dataset$test$y, verbose = 0)
}

save_mnist_model <- function(model_dir, model) {
    model_filepath <- paste(model_dir, "mnist_tf", sep="/")
    save_model_tf(object = model, filepath = model_filepath)
    return (model_filepath)
}

save_iris_model <- function(model_dir, model) {
    model_filepath <- paste(model_dir, "iris_rf", sep="/")
    model_file <- paste(model_filepath,  "iris_model.rds", sep = "/")
    saveRDS(object = model, file = model_file)
    return (model_file)
}

log <- function(message) {
    print(paste(Sys.time(), "*log*",message, sep=':'))
}
main <- function(tf, model_dir) {

    

    if (tf > 0) {
        log("Using tensorflow for training")

        log("Downloading dataset")
        dataset <- get_mnist_dataset()

        log("Building model")
        model <- get_mnist_model()

        log("Training model")
        model <- train_mnist_model(dataset, model)

        log("Saving model")
        model_filepath <- save_mnist_model(model_dir, model)

        log(paste("Saved model to", model_filepath))
    }
    else {
        # WIP TODO
        log("Using random forest for training")

        log("Downloading dataset")
        trainData <- get_iris_data()

        log("Training model")
        model <- train_iris_model(trainData)

        log("Saving model")
        model_file <- save_iris_model(model_dir, model)

        log(paste("Saved model to", model_file))
    }
}


if (!interactive()) {

    library(argparser)

    argp <- arg_parser("Training an mnist model")

    argp <- add_argument(argp, "--tf", help="argument used to determine whether to use tf during training or not, passing any number >0 will use tf", type="integer", default=0)

    argp <- add_argument(argp, "--modeldir", help="directory in which this script saves models, should be relative parth to current dir", type="string", default="models")
    argv <- parse_args(argp)

    main(tf=argv$tf, model_dir=argv$modeldir)
}