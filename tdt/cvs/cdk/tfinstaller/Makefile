LINDIR = ../linux

# To generate an image with initramfs containing the installer the
# following steps have to be executed:
# - remove the original (empty) initramfs file
# - generate and compress new initramfs
# - make a uImage containing the new initramfs
all:
	mv $(LINDIR)/arch/sh/boot/uImage ./uImage.org
	rm -f ./initramfs_data.cpio.gz.org
	mv $(LINDIR)/usr/initramfs_data.cpio.gz ./initramfs_data.cpio.gz.org
	$(LINDIR)/usr/gen_init_cpio initramfs_list > $(LINDIR)/usr/initramfs_data.cpio
	gzip -f -9 $(LINDIR)/usr/initramfs_data.cpio
	$(MAKE) -C $(LINDIR) ARCH=sh TF7700=y uImage
	rm -f $(LINDIR)/usr/initramfs_data.cpio.gz
	mv ./initramfs_data.cpio.gz.org $(LINDIR)/usr/initramfs_data.cpio.gz
	mv $(LINDIR)/arch/sh/boot/uImage .
	mv uImage.org $(LINDIR)/arch/sh/boot/uImage
	rm $(LINDIR)/../../../tufsbox/cdkroot/boot/uImage
	cp $(LINDIR)/arch/sh/boot/uImage $(LINDIR)/../../../tufsbox/cdkroot/boot/

TFP_OBJS = io.o encode.o decode.o maketree.o maketbl.o huf.o

tfpacker: $(TFP_OBJS)
	gcc -o $@ $(TFP_OBJS)

clean:
	rm -f $(TFP_OBJS)
	rm -f uImage

.c.o:
	gcc -c $< -Wall

$(TFP_OBJS): ar.h

