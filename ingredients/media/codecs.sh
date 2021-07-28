#!/bin/bash
#|#./ingredients/media/codecs.sh #Codecs for Audio, Images, and Video

# Audio Codecs (Lossless)
# FLAC: flac
# WavPak: wavpack
paru -S --noconfirm --needed flac wavpack

# Audio Codecs (Lossy)
# AAC: Encode = faac, Decode = faad2
# ATSC A/52: a52dec
# CELT: celt
# MPEG-1/MP3: Enocde = lame, Decode = libmad
# Musepack: libmpcdec
# Opus: opus
# Vorbis: libvorbis
# DTS Coherent Acoustics streams: libdca
paru -S --noconfirm --needed faac faad2 a52dec celt lame libmad libmpcdec opus libvorbis libdca

# Speech Codes
# AMR: opencore-amr
# Speex: speex
paru -S --noconfirm --needed opencore-amr speex

# Image Codecs
# JPEG 2000: jasper
# WebP: libwebp
# AVIF: libavif
# HEIF: libheif
paru -S --noconfirm --needed jasper libwebp libavif libheif

# Video Codecs
# AV1: dav1d
# DV: libdv
# H.265: x265
# H.264: x264
# MPEG-1, MPEG-2: libmpeg2
# MPEG-4: xvidcore
# Theora: libtheora
# VP8, VP9: libvpx
# ARIB STD-B24: aribb24
paru -S --noconfirm --needed dav1d libdv x265 x264 libmpeg2 xvidcore libtheora libvpx aribb24

# Additional
# X11 Video Extension Library: libxv
# Decode MPEG TS and DVB PSI Tables: libdvbpsi
# DVD Decryption
# Matroska Container Library
paru -S --noconfirm --needed libxv libdvbpsi libdvdcss libmatroska
