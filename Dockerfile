FROM rocker/ml:4.0.2 AS base

WORKDIR mnist

EXPOSE 8080

FROM base AS train

COPY train.R train.R

CMD [ "train.R", "--no-save" ]
ENTRYPOINT ["/usr/local/bin/Rscript"]