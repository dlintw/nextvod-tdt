changecom(`/*', `*/')dnl
ifdef(`rootsize',,`define(`rootsize',`0x240000')')dnl
ifdef(`datasize',,`define(`datasize',`0x400000')')dnl
define(`startaddr', `0xA0`'format(`%.2s', `'translit(`'eval($1,16), `a-z', `A-Z')).0000')
define(`endaddr', `0xA0`'format(`%.2s', `'translit(`'eval($1,16), `a-z', `A-Z')).FFFF')
/*
 * $Id$
 *
 * Chip mappings for the ST Microelectronics ST40STB1 and ST40GX1 based boards.
 * Adapted from physmap.c
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <asm/io.h>
#include <asm/errno.h>
#include <linux/mtd/mtd.h>
#include <linux/mtd/map.h>
#include <linux/mtd/partitions.h>

#define ONBOARD_ADDR 0x00000000

#if defined(CONFIG_SH_STB1_HARP)
#define ONBOARD_SIZE (8*1024*1024)
#define ONBOARD_BANKWIDTH 4
#elif defined(CONFIG_SH_GX1_EVAL)
#define ONBOARD_SIZE (16*1024*1024)
#define ONBOARD_BANKWIDTH 4
#elif defined(CONFIG_SH_MEDIAREF)
#define ONBOARD_SIZE (16*1024*1024)
#define ONBOARD_BANKWIDTH 4
#elif defined(CONFIG_SH_STB1_OVERDRIVE)
#define ONBOARD_SIZE 0
#define ONBOARD_BANKWIDTH 4
#elif defined(CONFIG_SH_STB1_EVAL)
#define ONBOARD_SIZE (4*1024*1024)
#define ONBOARD_BANKWIDTH 4
#elif defined(CONFIG_SH_ST40_STARTER)
#define ONBOARD_SIZE (8*1024*1024)
#define ONBOARD_BANKWIDTH 4
#elif defined(CONFIG_SH_STM8000_DEMO)
#define ONBOARD_SIZE (16*1024*1024)
#define ONBOARD_BANKWIDTH 2
#elif defined(CONFIG_SH_TMM_LR2)
#define ONBOARD_SIZE (8*1024*1024)
#define ONBOARD_BANKWIDTH 2
#elif defined(CONFIG_SH_STI5528_EVAL)
#define ONBOARD_SIZE (32*1024*1024)
#define ONBOARD_BANKWIDTH 4
#elif defined(CONFIG_SH_STI5528_ESPRESSO)
#define ONBOARD_SIZE (16*1024*1024)
#define ONBOARD_BANKWIDTH 4
#elif defined(CONFIG_SH_ST220_EVAL)
#define ONBOARD_SIZE (8*1024*1024)
#define ONBOARD_BANKWIDTH 2
#elif defined(CONFIG_SH_STB7100_MBOARD)
#define ONBOARD_SIZE (8*1024*1024)
#define ONBOARD_BANKWIDTH 2
#elif defined(CONFIG_SH_STB7100_REF)
#define ONBOARD_SIZE (16*1024*1024)
#define ONBOARD_BANKWIDTH 2
#elif defined(CONFIG_SH_STB7109E_REF)
#define ONBOARD_SIZE (8*1024*1024)
#define ONBOARD_BANKWIDTH 2
#else
#error Unknown board
#endif

#ifdef CONFIG_MTD_STBOARDS_STEM_ADDR
#define STEM_ADDR CONFIG_MTD_STBOARDS_STEM_ADDR
#define STEM_SIZE CONFIG_MTD_STBOARDS_STEM_SIZE
#endif

#if ONBOARD_SIZE > 0
static struct mtd_info *onboard_mtd;
#endif
#ifdef STEM_ADDR
static struct mtd_info *stem_mtd;
#endif

#define dprintk(x...)  printk(KERN_DEBUG x)
//#define dprintk(x...)

#if defined(CONFIG_SH_STB1_HARP) || \
    defined(CONFIG_SH_GX1_EVAL) || \
    defined(CONFIG_SH_ST40_STARTER) || \
    defined(CONFIG_SH_TMM_LR2) || \
    defined(CONFIG_SH_STI5528_EVAL) || \
    defined(CONFIG_SH_STB7100_MBOARD)
#define NEED_VPP
#include <asm/mach/harp.h>
#endif

#ifdef NEED_VPP
/*
 * The comments in mtd/map.h say that this needs to nest correctly,
 * but in practice vpp gets disabled without being first enabled,
 * so clearly this is not true. So ignore this, and simply enable and
 * disable as requested.
 */
static void stboards_set_vpp(struct map_info *map, int vpp)
{
	if (vpp) {
		harp_set_vpp_on();
	} else {
		harp_set_vpp_off();
	}
}
#endif

#if ONBOARD_SIZE > 0
static struct map_info onboard_map = {
	.name = "Onboard_Flash",
	.size = ONBOARD_SIZE,
	.bankwidth = ONBOARD_BANKWIDTH,
#ifdef NEED_VPP
	.set_vpp = stboards_set_vpp,
#endif
};
#endif

#ifdef STEM_ADDR
static struct map_info stem_map = {
	.name = "STEM Flash",
	.size = STEM_SIZE,
	.bankwidth = 4,
};
#endif

static struct mtd_partition onboard_partitions[9] = {
	{
	 .name = "Boot firmware :        0xA000.0000-0xA001.FFFF",
	 .size = 0x00020000,
	 .offset = 0x00000000,
	 },
	{ ifdef(`rootfs',`
	 .name = "Kernel -               0xA004.0000-0xA01F.FFFF",',`
	 .name = "Kernel -               0xA004.0000-0xA01F.FFFF",')
	 .size = 0x001C0000,
	 .offset = 0x00040000,
	 },
	{
	 .name = "Config FS -            0xA020.0000-0xA029.FFFF", 
	 .size = 0x000A0000, 
	 .offset = 0x00200000, 
	 }, 
	{ ifelse(rootfs,`cramfs',`
	 .name = "Root FS(CRAMFS)-       0xA02A.0000-`'endaddr(0x2A0000 + rootsize - 0x1)",',rootfs,`squashfs',`
	 .name = "Root FS(SQUASHFS)-     0xA02A.0000-`'endaddr(0x2A0000 + rootsize - 0x1)",',rootfs,`jffs2',`
	 .name = "Root FS(JFFS2)-        0xA02A.0000-`'endaddr(0x2A0000 + rootsize - 0x1)",',`
	 .name = "Root FS-               0xA02A.0000-`'endaddr(0x2A0000 + rootsize - 0x1)",')
	 .size = rootsize,
	 //.size = 0x00240000, 
	 .offset = 0x002A0000, 
	 }, 
	{
	 .name = "APP_Modules            `'startaddr(0x2A0000 + rootsize)-`'endaddr(0x1000000 - datasize - 0x120000 - 0x1)",
	 .size = 0x`'eval(0x1000000 - datasize - 0x120000 - rootsize - 0x2A0000,16), 
	 //.size = 0x00600000, 
	 .offset = 0x`'eval(0x2A0000 + rootsize,16), 
	 //.offset = 0x004E0000, 
	 }, 
	{
	 .name = "EmergencyRoot          `'startaddr(0x1000000 - datasize - 0x120000)-`'endaddr(0x1000000 - datasize - 0x1)",
	 .size = 0x00120000, 
	 .offset = 0x`'eval(0x1000000 - datasize - 0x120000,16), 
	 //.offset = 0x00AE0000, 
	 }, 
	{ ifelse(rootfs,`cramfs',`
	 .name = "OtherData | Var        `'startaddr(0x1000000 - datasize)-`'endaddr(0x1000000 - 0x1)",',rootfs,`squashfs',`
	 .name = "OtherData | Var        `'startaddr(0x1000000 - datasize)-`'endaddr(0x1000000 - 0x1)",',rootfs,`jffs2',`
	 .name = "OtherData              `'startaddr(0x1000000 - datasize)-`'endaddr(0x1000000 - 0x1)",',`
	 .name = "OtherData              `'startaddr(0x1000000 - datasize)-`'endaddr(0x1000000 - 0x1)",')
	 .size = datasize, 
	 //.size = 0x00400000, 
	 .offset = 0x`'eval(0x1000000 - datasize,16), 
	 //.offset = 0x00C00000, 
	 }, 
	{ 
	 .name = "BootConfiguration      0xA002.0000-0xA003.FFFF", 
	 .size = 0x00020000, 
	 .offset = 0x00020000, 
	 },
	{ 
	 .name = "Flash wo/ bootloader   0xA004.0000-0xA0FF.FFFF", 
	 .size = 0x00FC0000,
	 .offset = 0x00040000, 
	 }
};
static struct mtd_partition *parsed_parts;
static const char *probes[] = { "cmdlinepart", NULL };

int __init init_stboards(void)
{
	int nr_parts = 0;

#ifdef CONFIG_SH_STB1_HARP
	/* Enable writing to Flash */
	ctrl_outl(3, EPLD_FLASHCTRL);
#endif

#if ONBOARD_SIZE > 0
	printk(KERN_NOTICE
	       "Generic ST boards onboard flash device: 0x%08x (%d.%dMb) at 0x%08x\n",
	       ONBOARD_SIZE,
	       (ONBOARD_SIZE / (1024 * 1024)),
	       (ONBOARD_SIZE / ((1024 * 1024) / 10)) % 10, ONBOARD_ADDR);

	onboard_map.phys = ONBOARD_ADDR;
	onboard_map.size = ONBOARD_SIZE;
	onboard_map.virt =
	    (unsigned long *)ioremap(onboard_map.phys, onboard_map.size);
	dprintk("%s %s[%d] onboard_map.virt = 0x%08x\n", __FILE__, __FUNCTION__,
		__LINE__, (int)onboard_map.virt);
	if (onboard_map.virt == 0) {
		printk(KERN_ERR "Failed to ioremap onboard Flash\n");
	} else {
#ifndef CONFIG_MTD_COMPLEX_MAPPINGS
		simple_map_init(&onboard_map);
#endif
#if defined(CONFIG_SH_STB1_HARP) || defined(CONFIG_SH_STB1_EVAL)
		onboard_mtd = do_map_probe("jedec_probe", &onboard_map);
#else
		onboard_mtd = do_map_probe("cfi_probe", &onboard_map);
#endif
		if (onboard_mtd != NULL) {
			onboard_mtd->owner = THIS_MODULE;
#ifdef CONFIG_MTD_CMDLINE_PARTS
			nr_parts =
			    parse_mtd_partitions(onboard_mtd, probes,
						 &parsed_parts, 0);
#endif
			if (nr_parts <= 0)
				add_mtd_partitions(onboard_mtd,
						   onboard_partitions,
						   ARRAY_SIZE
						   (onboard_partitions));
			else
				add_mtd_partitions(onboard_mtd, parsed_parts,
						   nr_parts);
		} else {
			iounmap((void *)onboard_map.virt);
		}
	}
#endif

#ifdef STEM_ADDR
	printk(KERN_NOTICE
	       "Generic ST boards STEM flash device: 0x%08x at 0x%08x\n",
	       STEM_SIZE, STEM_ADDR);

	stem_map.phys = STEM_ADDR;
	stem_map.size = STEM_SIZE;
	stem_map.virt = (unsigned long)ioremap(stem_map.phys, stem_map.size);
	if (stem_map.virt == 0) {
		printk(KERN_ERR "Failed to ioremap STEM Flash\n");
	} else {
#ifndef CONFIG_MTD_COMPLEX_MAPPINGS
		simple_map_init(&stem_map);
#endif
		stem_mtd = do_map_probe("cfi_probe", &stem_map);
		if (stem_mtd != NULL) {
			stem_mtd->owner = THIS_MODULE;
#if ONBOARD_SIZE > 0
			add_mtd_device(stem_mtd);
#else
			add_mtd_partitions(stem_mtd, onboard_partitions,
					   ARRAY_SIZE(onboard_partitions));
#endif
		} else {
			iounmap((void *)stem_map.virt);
		}
	}
#endif

	return -ENXIO;
}

static void __exit cleanup_stboards(void)
{
#if ONBOARD_SIZE > 0
	if (onboard_mtd) {
		del_mtd_partitions(onboard_mtd);
		map_destroy(onboard_mtd);
	}
	if (onboard_map.virt != 0) {
		iounmap((void *)onboard_map.virt);
		onboard_map.virt = 0;
	}
#endif

#ifdef STEM_ADDR
	if (stem_mtd) {
		del_mtd_partitions(stem_mtd);
		map_destroy(stem_mtd);
	}
	if (stem_map.virt != 0) {
		iounmap((void *)stem_map.virt);
		stem_map.virt = 0;
	}
#endif
}

module_init(init_stboards);
module_exit(cleanup_stboards);
