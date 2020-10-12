FROM rocker/ml:4.0.2 AS base

WORKDIR prodr

EXPOSE 8080

RUN install2.r --error \
    argparser \
    randomForest \
    plumber

# Train target
FROM base AS train

COPY train.R train.R

CMD [ "train.R" ]
ENTRYPOINT ["/usr/local/bin/Rscript", "--no-save"]


# Deploy target
FROM base AS deploy

COPY app.R app.R
COPY plumber.R plumber.R
COPY predict.R predict.R

# This gets overridden by the model from s3 by sagemaker when deployed on sagemaker
COPY ./models/iris_rf/iris_model.rds /opt/ml/model/iris_model.rds

ENTRYPOINT [ "/usr/local/bin/Rscript", "--no-save", "app.R" ] 