# Synchronous-and-Asynchronous-FIFO
## FIFO (First-In First-Out) Buffer Memory

A FIFO (First-In First-Out) is a buffer memory that acts as an interface between peripherals operating at different speeds. It prevents data loss by temporarily storing data and releasing it in the same order as it was received, ensuring smooth and reliable data transfer.

## Synchronous FIFO:
A synchronous FIFO uses the same clock for both read and write operations. All operations are synchronized to a single clock edge.It is generally used in high-speed systems where modules operate using the same clock but at different data rates.

## Operations:

Write Operation: When the FIFO is not full and the write enable signal (wr_en) is high, data is written into the memory on each positive or negative edge of the clock. When all memory locations are filled (equal to the FIFO depth), it indicates a Full Condition. If more data is attempted to be written after this point, it leads to an Overflow Condition.

Read Operation: When the read enable signal (rd_en) is high and the FIFO is not empty, data is read from memory on each clock edge. When no data remains in the memory, it indicates an Empty Condition. If a read is attempted when the FIFO is empty, it leads to an Underflow Condition.

Simulation Results for overflow and underflow condition image
<img width="1551" height="670" alt="image" src="https://github.com/user-attachments/assets/1689db8c-f110-4d21-87e7-c66a6a5b47b7" />


# Asynchronous FIFO:
An asynchronous FIFO uses different clock signals for read and write operations. Since the clocks are independent, the operations are not synchronized, making it ideal for SoC designs or systems where modules operate at different clock speeds.

## Operations:

Write Operation: Controlled by the write clock (wr_clk). When wr_en is high and the FIFO is not full, data is written into memory. If the memory reaches its depth limit, it indicates a Full Condition, and writing beyond this limit causes an Overflow Condition.

Read Operation: Controlled by the read clock (rd_clk). When rd_en is high and data is available, it is read from memory. iIf all data has been read, it indicates an Empty Condition, and reading beyond this causes an Underflow Condition.

Asynchronous FIFOs operate with different clocks, synchronization flags or pointer synchronization techniques are used to ensure reliable data transfer between domains.

Simulation Results for Overflow
<img width="1564" height="679" alt="image" src="https://github.com/user-attachments/assets/32bf1455-1a73-4f6e-b1a6-6673d8ae6e80" />

