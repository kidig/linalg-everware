FROM jupyterhub/singleuser@sha256:5dd681bb378274d57c89116e9e1d4741716f72b90a6bda7d8397d1e1d6d89ef2

USER root

RUN apt-get update && \
    apt-get install --yes \
    libgl1-mesa-glx \
    git

USER jovyan

RUN pip install ipywidgets \
                matplotlib \
                numpy \
                pandas \
                scikit-learn \
                scipy \
                nose

USER root

RUN cd /tmp && \
    git clone https://github.com/Savichev-Igor/nbgrader.git && \
    cd nbgrader && \
    git checkout features && \
    pip install .

USER jovyan

RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

RUN jupyter nbextension install --sys-prefix --py nbgrader --overwrite
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader

# Disable assignment creating interface for user
RUN jupyter nbextension disable --sys-prefix create_assignment/main
RUN jupyter nbextension disable --sys-prefix formgrader/main --section=tree
RUN jupyter serverextension disable --sys-prefix nbgrader.server_extensions.formgrader

USER root

COPY static/ static/
RUN cat $HOME/static/custom/custom.js >> /opt/conda/lib/python3.6/site-packages/notebook/static/custom/custom.js
