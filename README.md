# High-Capacity-Reversible-Data-Hiding-in-Encrypted-Images-using-Adaptive-Encoding

A High capacity lossless data hiding scheme for JPEG images. [paper link](https://arxiv.org/abs/1905.05627v2 )

## Abstract

JPEG is the most popular image format, which is widely used in our daily life. Therefore, reversible data hiding (RDH) for JPEG images is important. Most of the RDH schemes for JPEG images will cause significant distortions and large file size increments in the marked JPEG image. As a special case of RDH, the lossless data hiding (LDH) technique can keep the visual quality of the marked images no degradation. In this paper, a novel high capacity LDH scheme is proposed. In the JPEG bitstream, not all the variable length codes (VLC) are used to encode image data. By constructing the mapping between the used and unused VLCs, the secret data can be embedded by replacing the used VLC with the unused VLC. Different from the previous schemes, our mapping strategy allows the lengths of unused and used VLCs in a mapping set to be unequal. We present some basic insights into the construction of the mapping relationship. Experimental results show that most of the JPEG images using the proposed scheme obtain smaller file size increments than previous RDH schemes. Furthermore, the proposed scheme can obtain high embedding capacity while keeping the marked JPEG image with no distortion.

## 摘要
JPEG是最流行的图像格式，在我们的日常生活中被广泛使用。因此，JPEG图像的可逆信息隐藏（RDH）很重要。 JPEG图像的大多数RDH方案都会在标记的JPEG图像中引起严重的失真和较大的文件大小增量。作为RDH的特例，无损信息隐藏（LDH）技术可以使载密图像的视觉质量保持不变。本文提出了一种新颖的大容量LDH方案。在JPEG位流中，并非所有可变长度代码（VLC）都用于编码图像数据。通过构造已使用和未使用的VLC之间的映射，可以通过将未使用的VLC替换为未使用的VLC来嵌入秘密数据。与以前的方案不同，我们的映射策略允许映射集中未使用和已使用的VLC的长度不相等。我们提出了一些有关映射关系构建的基本见解。实验结果表明，与以前的RDH方案相比，使用所提出的方案的大多数JPEG图像均获得较小的文件大小增量。此外，提出的方案可以获得高嵌入能力，同时保持标记的JPEG图像无失真。

## Code running environment

The code has been tested by Matlab R2018b on Windows 10. 

## How to use

- Please see the comparison results before and after extraction in `demo_gvm.m`. The experimental results demonstrate our code can achieve the feature of high capacity and lossless, which are referred in our paper.

- You can run the  `demo_embed.m` to see the related results of embedding. In  `demo_embed.m`, the test image is `Boat_70.jpg`, which quality factor = 70.


- You can run the  `demo_extract.m` to see the related results of extraction. In  `demo_extract.m`, the extracted image is `stego.jpg`, which is the stego version of `Boat_70.jpg`.
- Other related functions are all listed in out repositories.

## Tips

If you find any problems, please feel free to contact to the authors ([duyang@stu.ahu.edu.cn](mailto:duyang@stu.ahu.edu.cn)).



