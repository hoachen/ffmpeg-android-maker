#!/usr/bin/env bash

case $ANDROID_ABI in
  x86)
    # Disabling assembler optimizations, because they have text relocations
    EXTRA_BUILD_CONFIGURATION_FLAGS=--disable-asm
    ;;
  x86_64)
    EXTRA_BUILD_CONFIGURATION_FLAGS=--x86asmexe=${FAM_YASM}
    ;;
esac

if [ "$FFMPEG_GPL_ENABLED" = true ] ; then
    EXTRA_BUILD_CONFIGURATION_FLAGS="$EXTRA_BUILD_CONFIGURATION_FLAGS --enable-gpl"
fi

# Preparing flags for enabling requested libraries
ADDITIONAL_COMPONENTS=
for LIBARY_NAME in ${FFMPEG_EXTERNAL_LIBRARIES[@]}
do
  ADDITIONAL_COMPONENTS+=" --enable-$LIBARY_NAME"
done

# Referencing dependencies without pkgconfig
DEP_CFLAGS="-I${BUILD_DIR_EXTERNAL}/${ANDROID_ABI}/include"
DEP_LD_FLAGS="-L${BUILD_DIR_EXTERNAL}/${ANDROID_ABI}/lib $FFMPEG_EXTRA_LD_FLAGS"

./configure \
  --prefix=${BUILD_DIR_FFMPEG}/${ANDROID_ABI} \
  --enable-cross-compile \
  --target-os=android \
  --arch=${TARGET_TRIPLE_MACHINE_ARCH} \
  --sysroot=${SYSROOT_PATH} \
  --cc=${FAM_CC} \
  --cxx=${FAM_CXX} \
  --ld=${FAM_LD} \
  --ar=${FAM_AR} \
  --as=${FAM_CC} \
  --nm=${FAM_NM} \
  --ranlib=${FAM_RANLIB} \
  --strip=${FAM_STRIP} \
  --extra-cflags="-O3 -fPIC $DEP_CFLAGS" \
  --extra-ldflags="$DEP_LD_FLAGS" \
  --disable-shared \
  --enable-static \
  --disable-ffmpeg\
  --disable-ffplay\
  --disable-ffprobe\
  --disable-doc \
  --disable-htmlpages\
  --disable-manpages\
  --disable-podpages\
  --disable-txtpages\
  --disable-avdevice\
  --enable-avcodec\
  --enable-avformat\
  --enable-avutil\
  --enable-swresample\
  --enable-swscale\
  --disable-avfilter\
  --disable-postproc\
  --disable-filters\
  --enable-network\
  --enable-libdav1d\
  --disable-d3d11va\
  --disable-dxva2\
  --disable-vaapi\
  --disable-vdpau\
  --disable-videotoolbox\
  --disable-encoders\
  --disable-decoders\
  --enable-decoder=aac\
  --enable-decoder=aac_latm\
  --enable-decoder=ac3\
  --enable-decoder=h264\
  --enable-decoder=mp3*\
  --enable-decoder=eac3\
  --enable-decoder=hevc\
  --enable-decoder=vp9\
  --enable-decoder=opus\
  --enable-decoder=vorbis\
  --enable-decoder=mpeg4\
  --enable-decoder=mp1\
  --enable-decoder=mp2\
  --enable-decoder=mpeg2video\
  --enable-decoder=rv10\
  --enable-decoder=rv20\
  --enable-decoder=rv30\
  --enable-decoder=rv40\
  --enable-decoder=vp8\
  --enable-decoder=nellymoser\
  --enable-decoder=cook\
  --enable-decoder=mjpeg\
  --enable-decoder=msmpeg4v1\
  --enable-decoder=msmpeg4v2\
  --enable-decoder=msmpeg4v3\
  --enable-decoder=amrnb\
  --enable-decoder=ralf\
  --enable-decoder=alac\
  --enable-decoder=wmav1\
  --enable-decoder=wmav2\
  --enable-decoder=wmv1\
  --enable-decoder=wmv2\
  --enable-decoder=h261\
  --enable-decoder=h263\
  --enable-decoder=flac\
  --enable-decoder=libdav1d\
  --enable-decoder=movtext\
  --enable-decoder=flv\
  --enable-decoder=adpcm*\
  --enable-decoder=mpeg1video\
  --disable-hwaccels\
  --disable-muxers\
  --disable-demuxers\
  --enable-demuxer=aac\
  --enable-demuxer=hls\
  --enable-demuxer=mov\
  --enable-demuxer=mp4\
  --enable-demuxer=m4a\
  --enable-demuxer=3gp\
  --enable-demuxer=3g2\
  --enable-demuxer=mj2\
  --enable-demuxer=mp3\
  --enable-demuxer=amr\
  --enable-demuxer=mpegts\
  --enable-demuxer=flv\
  --enable-demuxer=webm_dash_manifest\
  --enable-demuxer=detached\
  --enable-demuxer=matroska\
  --enable-demuxer=asf\
  --enable-demuxer=avi\
  --enable-demuxer=m4v\
  --enable-demuxer=rm\
  --enable-demuxer=ogg\
  --enable-demuxer=mpegps\
  --enable-demuxer=mpegvideo\
  --enable-demuxer=ext_hls\
  --disable-parsers\
  --enable-parser=aac\
  --enable-parser=aac_latm\
  --enable-parser=h264\
  --enable-parser=flac\
  --enable-parser=hevc\
  --enable-parser=opus\
  --enable-parser=mpeg4video\
  --enable-parser=mpegvideo\
  --enable-parser=mpegaudio\
  --disable-bsfs\
  --enable-bsf=extract_extradata\
  --enable-bsf=aac_adtstoasc\
  --enable-bsf=h264_mp4toannexb\
  --enable-bsf=hevc_mp4toannexb\
  --enable-bsf=av1_metadata\
  --disable-protocols\
 --enable-protocol=async\
 --enable-protocol=hls\
  --enable-protocol=http\
  --enable-protocol=file\
  --enable-protocol=tcp\
#  --enable-protocol=udp\
  --enable-protocol=crypto\
  --enable-protocol=rtmp\
  --disable-devices\
  --disable-filters\
  --disable-iconv\
  --disable-audiotoolbox\
  --disable-videotoolbox\
  --pkg-config=${PKG_CONFIG_EXECUTABLE} \
  ${EXTRA_BUILD_CONFIGURATION_FLAGS} \
  $ADDITIONAL_COMPONENTS || exit 1

${MAKE_EXECUTABLE} clean
${MAKE_EXECUTABLE} -j${HOST_NPROC}
${MAKE_EXECUTABLE} install
