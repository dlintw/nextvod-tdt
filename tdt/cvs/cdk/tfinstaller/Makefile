LINDIR = ../linux-sh4

# To generate an image with initramfs containing the installer the
# following steps have to be executed:
# - remove the original (empty) initramfs file
# - generate and compress new initramfs
# - make a uImage containing the new initramfs
all:
	pwd
	mv $(LINDIR)/arch/sh/boot/uImage uImage.org
	rm -f initramfs_data.cpio
	mv $(LINDIR)/usr/initramfs_data.cpio initramfs_data.cpio.org
	$(LINDIR)/usr/gen_init_cpio initramfs_list > $(LINDIR)/usr/initramfs_data.cpio

	#Build Kernel containing initramfs
	$(MAKE) -C $(LINDIR) ARCH=sh TF7700=y uImage

	rm -f $(LINDIR)/usr/initramfs_data.cpio
	mv initramfs_data.cpio.org $(LINDIR)/usr/initramfs_data.cpio
	mv $(LINDIR)/arch/sh/boot/uImage.gz uImage
	mv uImage.org $(LINDIR)/arch/sh/boot/uImage.gz

TFP_OBJS = io.o encode.o decode.o maketree.o maketbl.o huf.o

tfpacker: $(TFP_OBJS)
	gcc -o $@ $(TFP_OBJS)

clean:
	rm -f $(TFP_OBJS)
	rm -f uImage

.c.o:
	gcc -c $< -Wall

$(TFP_OBJS): ar.h

