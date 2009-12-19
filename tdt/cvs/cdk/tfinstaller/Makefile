LINDIR = ../linux

# To generate an image with initramfs containing the installer the
# following steps have to be executed:
# - remove the original (empty) initramfs file
# - generate and compress new initramfs
# - make a uImage containing the new initramfs
all:
	rm -f $(LINDIR)/usr/initramfs_data.cpio.gz
	$(LINDIR)/usr/gen_init_cpio initramfs_list > $(LINDIR)/usr/initramfs_data.cpio
	gzip -f -9 $(LINDIR)/usr/initramfs_data.cpio
	$(MAKE) -C $(LINDIR) TF7700=y uImage
	rm -f $(LINDIR)/usr/initramfs_data.cpio.gz
	cp $(LINDIR)/arch/sh/boot/uImage .
		

TFP_OBJS = io.o encode.o decode.o maketree.o maketbl.o huf.o

tfpacker: $(TFP_OBJS)
	gcc -o $@ $(TFP_OBJS)

clean:
	rm -f $(TFP_OBJS)
	rm -f uImage

.c.o:
	gcc -c $< -Wall

$(TFP_OBJS): ar.h

