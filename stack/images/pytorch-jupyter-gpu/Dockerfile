FROM wwbrannon/pytorch-jupyter-gpu:latest

ARG NB_UID
ARG NB_GID
ARG NB_USER

ENV HOME=/home/$NB_USER

RUN groupadd -g 11 wheel && \
    groupadd -g $NB_GID $NB_UID && \
    echo "%wheel         ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -m -s /bin/bash -N -g $NB_GID -G wheel -d $HOME \
            -u $NB_UID $NB_USER && \
    mkdir /home/$NB_USER/notebooks

COPY pw /root/pw
RUN echo "$NB_USER:$(cat /root/pw)" | chpasswd && \
    rm -f /root/pw

RUN fix-permissions $HOME /etc/jupyter/

WORKDIR $HOME
CMD ["start.sh"]

