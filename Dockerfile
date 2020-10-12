FROM rocker/ml:4.0.2 AS base

WORKDIR mnist

EXPOSE 8080

RUN install2.r --error \
    argparser

FROM base AS train

COPY train.R train.R

CMD [ "train.R" ]
ENTRYPOINT ["/usr/local/bin/Rscript", "--no-save"]