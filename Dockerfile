# Lowcoder all-in-one image, pinned by version and digest.
# The embedded MongoDB and Redis are switched off by railway-start.sh:
# the template runs Railway's own MongoDB and Redis services instead.
FROM lowcoderorg/lowcoder-ce:2.7.6@sha256:4a8b800a9454108546808cc88ed3305cc2533fb25b89326c26139848254dbd61

# Send every service's log (api-service, node-service, nginx) to the container
# output, so it shows in Railway's log view instead of only in files.
RUN sed -i \
      -e 's#^stdout_logfile=.*#stdout_logfile=/dev/stdout#' \
      -e 's#^stdout_logfile_maxbytes=.*#stdout_logfile_maxbytes=0#' \
      -e 's#^stderr_logfile_maxbytes=.*#stderr_logfile_maxbytes=0#' \
      -e 's#^stdout_logfile_backups=.*#stdout_logfile_backups=0#' \
      -e 's#^stderr_logfile_backups=.*#stderr_logfile_backups=0#' \
      /lowcoder/etc/supervisord/conf-available/*.conf

COPY --chmod=755 railway-start.sh /lowcoder/railway-start.sh

EXPOSE 3000
ENTRYPOINT ["/bin/bash", "/lowcoder/railway-start.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/lowcoder/etc/supervisord.conf"]
