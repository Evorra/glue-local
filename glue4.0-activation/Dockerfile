FROM docker.io/amazon/aws-glue-libs:glue_libs_4.0.0_image_01

ENV PYTHONPATH="${PYTHONPATH}:/home/glue_user/workspace"

RUN /home/glue_user/.local/bin/pip install facebook_business google-ads google-auth google-auth-oauthlib google-api-python-client paramiko PyJWT retrying
RUN /home/glue_user/.local/bin/pip install moto pytest-mock

WORKDIR /home/glue_user/workspace

CMD ["bash"]
