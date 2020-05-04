############################################################
# Dockerfile that builds a Post-Scriptum Gameserver
############################################################
FROM cm2network/steamcmd:steam

LABEL maintainer="e.sanguin.92@gmail.com"

ENV STEAMAPPID 746200
ENV STEAMAPPDIR /home/steam/post-scriptum-dedicated

# Run Steamcmd and install Post-Scriptum Server
RUN set -x \
	&& "${STEAMCMDDIR}/steamcmd.sh" \
		+login anonymous \
		+force_install_dir ${STEAMAPPDIR} \
		+app_update ${STEAMAPPID} validate \
		+quit

ENV PORT=10027 \
	QUERYPORT=10037 \
	RCONPORT=10047 \
	FIXEDMAXPLAYERS=80 \
	RANDOM=NONE

WORKDIR $STEAMAPPDIR

VOLUME $STEAMAPPDIR

# Set Entrypoint
# 1. Update server
# 2. Start server
ENTRYPOINT ${STEAMCMDDIR}/steamcmd.sh \
		+login anonymous +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} +quit \
		&& ${STEAMAPPDIR}/SquadGameServer.sh \
			Port=$PORT QueryPort=$QUERYPORT RCONPORT=$RCONPORT FIXEDMAXPLAYERS=$FIXEDMAXPLAYERS RANDOM=$RANDOM

# Expose ports
EXPOSE 10027/tcp \
	10027/udp \
	10037/tcp \
	10037/udp \
	10047/tcp \
	10047/udp
