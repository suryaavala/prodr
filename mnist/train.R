# https://tensorflow.rstudio.com/tutorials/beginners/
library(keras)


mnist <- dataset_mnist()
mnist$train$x <- mnist$train$x/255
mnist$test$x <- mnist$test$x/255


model <- keras_model_sequential() %>% 
  layer_flatten(input_shape = c(28, 28)) %>% 
  layer_dense(units = 128, activation = "relu") %>% 
  layer_dropout(0.2) %>% 
  layer_dense(10, activation = "softmax")

print(summary(model))


model %>% 
  compile(
    loss = "sparse_categorical_crossentropy",
    optimizer = "adam",
    metrics = "accuracy"
  )

model %>% 
  fit(
    x = mnist$train$x, y = mnist$train$y,
    epochs = 5,
    validation_split = 0.3,
    verbose = 2
  )

predictions <- predict(model, mnist$test$x)
print(head(predictions, 2))

model %>% 
  evaluate(mnist$test$x, mnist$test$y, verbose = 0)


save_model_tf(object = model, filepath = "model")

reloaded_model <- load_model_tf("model")
all.equal(predict(model, mnist$test$x), predict(reloaded_model, mnist$test$x))
