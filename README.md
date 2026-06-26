# Cliff Cummings Asynchronous FIFO Design

An asynchronous FIFO (First-In-First-Out) is a digital design block used to safely and efficiently transfer data between systems running in different clock domains. Cliff Cummings has provided methods that are considered the industry standard for asynchronous FIFO design and has made important contributions in this area. This README summarizes Cummings's asynchronous FIFO design principles and use cases.

## What is an Asynchronous FIFO?
An asynchronous FIFO is a memory structure where data is written from one clock domain (the write clock) and read from another clock domain (the read clock). Its main purpose is to provide data synchronization between two systems running at different frequencies or phases. This design uses special techniques such as synchronizer circuits and Gray code to reduce the risk of metastability.

## Cliff Cummings's Design Principles
Cliff Cummings's asynchronous FIFO design is based on the following key principles:
- **Use of Gray Code**: The write and read pointers are encoded in Gray code. This minimizes bit changes when crossing between clock domains and reduces the risk of metastability.
- **Synchronization**: The write pointer is synchronized into the read clock domain, and the read pointer is synchronized into the write clock domain. This is usually done with two-stage flip-flop synchronizers.
- **Empty/Full Status Check**: Pointer comparisons are used to determine whether the FIFO is empty or full. Cummings provides algorithms that make these checks reliable and correct.
- **Modular Design**: The FIFO design is modular so it can be reused and easily adapted to different applications.

## Use Cases
Asynchronous FIFOs are commonly used in the following areas:
- **Data Transfer Between Different Clock Domains**: Data transfer between processors, memory units, or communication interfaces.
- **System Integration**: Building data bridges between different protocols or modules in FPGA or ASIC based systems.
- **Communication Systems**: Data buffering in Ethernet, USB, or other high-speed serial protocols.
- **Real-Time Processing**: Processing sensor data or streaming data at different rates.

# Design Components

## Connections
The image shows all the connections of the related RTL codes with the IP integrator.


<img width="1806" height="819" alt="Screenshot 2025-09-27 170302" src="https://github.com/user-attachments/assets/d659d452-490f-48f0-b0eb-eb7086e05188" />


## async_fifo_rtl_bin_to_gray
The address coming into the module is converted to Gray code and sent to the output.


<img width="787" height="364" alt="image" src="https://github.com/user-attachments/assets/bd434d76-c583-48df-8f56-ad77b6691691" />


## async_fifo_rtl_empty
This module takes the write Gray code that has passed through the 2FF synchronizer and increments the read address if the conditions are met. If the conditions are not met, the read address stays the same.


<img width="1034" height="439" alt="image" src="https://github.com/user-attachments/assets/3db7a935-aa21-42b7-97cc-685ffbe021a9" />


## async_fifo_rtl_full
This module works similarly to async_fifo_rtl_empty. It takes the read Gray code that has passed through the 2FF synchronizer and increments the write address if the conditions are met. If the conditions are not met, the write address stays the same.


<img width="1026" height="446" alt="image" src="https://github.com/user-attachments/assets/f149ed46-267c-46f7-8d9d-d6a80372a57c" />


## async_fifo_rtl_gray_sync
The read address coming into the module is converted to Gray code for the write domain, and this result is passed through a 2FF synchronizer and sent to the output. The same is done for the write address.


<img width="1011" height="511" alt="image" src="https://github.com/user-attachments/assets/ef126a16-0d96-4907-9cb9-d4a73433f957" />


## async_fifo_rtl_mem
This is the module where our memory is located and where the write and read operations are performed.


<img width="978" height="713" alt="image" src="https://github.com/user-attachments/assets/987bf311-f168-4e99-88f4-2ccc4d51e99b" />


## async_fifo_rtl_reset_sync
Here, when the asynchronously arriving reset goes to the 1 state, it is passed through a 2FF synchronizer against the risk of metastability. In other words, while the reset operation is applied asynchronously, the de-reset operation is applied synchronously.


<img width="990" height="514" alt="image" src="https://github.com/user-attachments/assets/7c6c93fb-1e26-4d36-ba78-d4577782d8a0" />


## async_fifo_rtl_top
This is the top module where all modules are combined and signal connections are made.


<img width="750" height="615" alt="image" src="https://github.com/user-attachments/assets/f38fcf0e-2bf1-43b7-83e4-281e4e83de36" />


# Test Results

### tb_async_fifo_rtl_empty results:
<img width="1799" height="190" alt="image" src="https://github.com/user-attachments/assets/9b2fb0a4-fef8-4f31-997c-88763e2aa949" />

### tb_async_fifo_rtl_full results:
<img width="1807" height="198" alt="image" src="https://github.com/user-attachments/assets/ce0772a3-1c9f-4a14-b0ce-c7ea68a59280" />

### tb_async_fifo_rtl_gray_sync results:
<img width="1692" height="254" alt="image" src="https://github.com/user-attachments/assets/a6ff47e5-0fc2-4f80-bf7e-0a45d168708a" />
- The signal shifts here are caused by the difference between the domains.

### tb_async_fifo_rtl_mem results:
<img width="1808" height="259" alt="image" src="https://github.com/user-attachments/assets/3828d2f6-9b54-4ecc-b581-234f865b9347" />

### tb_async_fifo_rtl_reset_sync results:
<img width="1884" height="163" alt="image" src="https://github.com/user-attachments/assets/f9eef5b4-f650-4234-a08c-09c8ae11fa41" />
- Here, the sync_rstn signal is passed through a 2FF synchronizer to prevent metastability, which causes a delay.

### tb_async_fifo_rtl_top results:
<img width="1871" height="299" alt="image" src="https://github.com/user-attachments/assets/0a362388-0ba9-4567-997b-f3ecf7fbfdf6" />






# References I used:

  ->https://www.youtube.com/playlist?list=PL6jcjOP0HjMpLtYgpWJzhe4uPfGimq0Cy
  
  ->https://zipcpu.com/blog/2018/07/06/afifo.html
  
  ->https://vlsiverify.com/verilog/verilog-codes/asynchronous-fifo/
  
  ->https://www.verilogpro.com/asynchronous-fifo-design/
  
  ->https://www.paradigm-works.com/technical-library?term=simulation+and+synthesis+techniques+for+asynchronous+fifo+design
  
  ->https://www.ti.com/lit/an/scaa042a/scaa042a.pdf
