# -*- Baking Pi tutorial from cam.ac.uk -*-
#
# Makefile, to build a kernel.img used on the Raspberry Pi.
#
# Requires ARMv6 assemblers:
#   https://launchpad.net/gcc-arm-embedded
#
# Author: Chris Corbyn <chris@w3style.co.uk>

# Prefix of the ARM compiler binaries
ARMGNU = arm-none-eabi
# Source directory, containing .s files
SOURCE = source/
# Temporary build products directory
BUILD  = build/
# Output file name
TARGET = kernel.img
# Linker script name
LINKER = kernel.ld

# Build all targets
all: $(TARGET)

# Build the kernel.img file in plain binary format
$(TARGET): $(BUILD)$(TARGET).elf
	$(ARMGNU)-objcopy -O binary $(BUILD)$(TARGET).elf $(TARGET)

# Build the kernel.img.elf file, in ELF executable format
$(BUILD)$(TARGET).elf: $(BUILD)$(TARGET).o
	$(ARMGNU)-ld --no-undefined -o $(BUILD)$(TARGET).elf $(BUILD)$(TARGET).o -T $(LINKER)

# Assemble the kernel.img.o object file
$(BUILD)$(TARGET).o:
	$(ARMGNU)-as $(SOURCE)*.s -o $(BUILD)$(TARGET).o

# Remove built products and intermediate files
clean:
	rm -f $(BUILD)$(TARGET).elf
	rm -f $(BUILD)$(TARGET).o
	rm -f $(TARGET)
