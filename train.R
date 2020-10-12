#!/usr/local/bin/Rscript
# https://tensorflow.rstudio.com/tutorials/beginners/
library(keras)

get_dataset <- function() {
    mnist <- dataset_mnist()
    mnist$train$x <- mnist$train$x/255
    mnist$test$x <- mnist$test$x/255
    return (mnist)
}

get_model <- function() {
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


train_model <- function(dataset, model) {
    model %>% 
    fit(
        x = dataset$train$x, y = dataset$train$y,
        epochs = 5,
        validation_split = 0.3,
        verbose = 2
    )

    return (model)
}

evaluate_model <- function(dataset, model) {
    predictions <- predict(model, dataset$test$x)

    model %>% 
    evaluate(dataset$test$x, dataset$test$y, verbose = 0)
}

save_model <- function(filepath, model) {
    save_model_tf(object = model, filepath = filepath)
}

log <- function(message) {
    print(paste(Sys.time(), "*log*",message, sep=':'))
}
main <- function() {

    log("Downloading dataset")
    dataset <- get_dataset()

    log("Building model")
    model <- get_model()

    log("Training model")
    model <- train_model(dataset, model)

    log("Saving model")
    model_dir <- "models"
    model_filepath <- paste(model_dir, "mnist_tf", sep="/")
    save_model(model_filepath, model)

    log(paste("Saved model to", model_filepath))
}


if (!interactive()) {
  main()
}