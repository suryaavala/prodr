#!/usr/local/bin/Rscript
# https://tensorflow.rstudio.com/tutorials/beginners/
library(keras)

get_dataset <- function() {
    mnist <- dataset_mnist()
    mnist$train$x <- mnist$train$x/255
    mnist$test$x <- mnist$test$x/255
    return (mnist)
}

get_tf_model <- function() {
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


train_tf_model <- function(dataset, model) {
    model %>% 
    fit(
        x = dataset$train$x, y = dataset$train$y,
        epochs = 5,
        validation_split = 0.3,
        verbose = 2
    )

    return (model)
}

evaluate_tf_model <- function(dataset, model) {
    predictions <- predict(model, dataset$test$x)

    model %>% 
    evaluate(dataset$test$x, dataset$test$y, verbose = 0)
}

save_tf_model <- function(model_dir, model) {
    model_filepath <- paste(model_dir, "mnist_tf", sep="/")
    save_model_tf(object = model, filepath = model_filepath)
    return (model_filepath)
}

log <- function(message) {
    print(paste(Sys.time(), "*log*",message, sep=':'))
}
main <- function(tf, model_dir) {

    log("Downloading dataset")
    dataset <- get_dataset()

    if (tf > 0) {
        log("Using tensorflow for training")
        log("Building model")
        model <- get_tf_model()

        log("Training model")
        model <- train_tf_model(dataset, model)

        log("Saving model")
        model_filepath <- save_tf_model(model_dir, model)

        log(paste("Saved model to", model_filepath))
    }
    else {
        # TODO
        log("Using random forest for training")
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