#!/usr/local/bin/Rscript
# plumber.R

#* Ping to show server is there
#* @get /ping
function() { 
  return('')
}

## NOTE This route doesn't necessarily have to be /invocations if deploying anywhere other than sagemaker (see: https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-inference-code.html#your-algorithms-inference-code-container-response)
#* Parse input and return prediction from model
#* @parser json
#* @post /invocations
function(req){

  # https://www.rplumber.io/articles/routing-and-input.html#the-request-object-1
  predictions <- get_predictions(req$body)
  
  return (predictions)
}