#include <stdint.h>

struct MB_header {
    uint32_t magic;
    uint32_t flags;
    uint32_t checksum;
    uint32_t header_addr;
    uint32_t load_addr;
    uint32_t load_end_addr;
    uint32_t bss_end_addr;
    uint32_t entry_addr;
    uint32_t mode_type;
    uint32_t width;
    uint32_t height;
    uint32_t depth;
};

struct MB_boot_information {
    uint32_t flags;

    uint32_t *mem_lower;
    uint32_t *mem_upper;

    uint32_t boot_device;

    uint32_t cmdline;

    uint32_t mods_count;
    uint32_t *mods_addr;

    uint32_t syms[3];

    uint32_t mmap_length;
    uint32_t *mmap_addr;

    uint32_t drives_length;
    uint32_t *drives_addr;

    uint32_t config_table;

    char * boot_loader_name;

    uint32_t apm_table;

    uint32_t vbe_control_info;
    uint32_t vbe_mode_info;
    uint32_t vbe_mode;
    uint32_t vbe_interface_seg;
    uint32_t vbe_interface_off;
    uint32_t vbe_interface_len;

    uint32_t *framebuffer_addr;
    uint32_t pad_;
    uint32_t framebuffer_pitch;
    uint32_t framebuffer_width;
    uint32_t framebuffer_height;
    uint8_t framebuffer_bpp;
    uint8_t framebuffer_type;
    uint8_t color_info[5];
};
