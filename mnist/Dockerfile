FROM rocker/ml:4.0.2

COPY . .

EXPOSE 8080

CMD [ "train.R", "--no-save" ]
ENTRYPOINT ["/usr/local/bin/Rscript"]