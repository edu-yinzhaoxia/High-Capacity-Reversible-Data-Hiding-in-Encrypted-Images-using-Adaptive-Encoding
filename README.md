# High-Capacity-Reversible-Data-Hiding-in-Encrypted-Images-using-Adaptive-Encoding

 High-Capacity-Reversible-Data-Hiding-in-Encrypted-Images-using-Adaptive-Encoding.[paper link](https://arxiv.org/abs/2102.12620 )

## Abstract
With the popularization of digital information technology, the reversible data hiding in encrypted images (RDHEI) has gradually become the research hotspot of privacy protection in cloud storage. As a technology which can embed additional information in encrypted domain, extract the embedded information correctly and recover the original image without loss, RDHEI has been widely paid attention by researchers. To embed sufficient additional information in the encrypted image, a high-capacity RDHEI method using adaptive encoding is proposed in this paper. Firstly, the occurrence frequency of different prediction errors of the original image is calculated and the corresponding adaptive Huffman coding is generated. Then, the original image is encrypted with stream cipher and the encrypted pixels are marked with different Huffman codewords according to the prediction errors. Finally, additional information is embedded in the reserved room of marked pixels by bit substitution. The experimental results show that the proposed algorithm can extract the embedded information correctly and recover the original image losslessly. Compared with similar algorithms, the proposed algorithm makes full use of the characteristics of the image itself and greatly improves the embedding rate of the image. On UCID, BOSSBase, and BOWS-2 datasets, the average embedding rate of the proposed algorithm reaches 3.162 bpp, 3.917 bpp, and 3.775 bpp, which is higher than the state-of-the-art algorithm of 0.263 bpp, 0.292 bpp, and 0.280 bpp, respectively.


## 摘要
随着数字信息技术的普及,密文可逆信息隐藏(Reversible Data Hiding in Encrypted Images, RDHEI)逐渐成为云存储中隐私保护的研究热点.RDHEI作为一种能在密文中嵌入额外信息,并正确提取嵌入信息和无损恢复原始图像的技术,受到研究者的广泛关注.为了能在加密图像中嵌入充足的额外信息,本文提出了一种自适应编码的高容量RDHEI算法.首先,计算原始图像不同预测误差的出现概率并自适应的生成哈夫曼编码;然后,利用流密码加密原始图像,根据像素预测误差对应的哈夫曼码字对加密后像素进行标记;最后,以位替换方式将信息嵌入到已标记像素的预留空间中.经实验验证,本文算法在正确提取嵌入信息的同时,无损地恢复了原始图像.与同类算法相比,本文算法充分利用了图像本身的纹理特性,有效地提高了图像嵌入率.在UCID、BOSSBase和BOWS-2三个图像集上,本文算法的平均嵌入率达到3.162bpp、3.917bpp以及3.775bpp,与当前性能最佳算法相比提升了0.263bpp、0.292bpp以及0.280bpp.


## How to use
代码使用说明：用MATLAB软件直接运行主函数Main.m即可

联系人姓名：吴友情
联系人邮箱：wuyq.hfnu@qq.com



主函数：Main.m
数据集主函数：Main_BOSSbase.m
	        Main_BOWS2OrigEp3.m
	        Main_UCID.m

图像加密与数据嵌入模块
函数：Encrypt_Embed.m
求预测误差：Predictor_Error.m
二叉树编码标记位图：BinaryTree_Mark.m
图像加密：Encrypt_Image.m
数据嵌入：Embed_Data.m
数据加密：Encrypt_Data.m

数据提取模块
函数：Extract_Data.m
数据解密：Encrypt_Data.m

图像恢复模块：Recover_Image.m

辅助函数：
求结构相似度：SSIM.m
求峰值信噪比：PSNR.m
十进制转8位二进制：Decimalism_Binary.m
8位二进制转十进制：Binary_Decimalism.m






