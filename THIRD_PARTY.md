# Third-party components

Nothing third-party is redistributed in this repository: there is no vendored code, no binary, and no dataset. The items below are used at run time or credited as the origin of the method.

## Used at run time, not distributed

| Component | Provides | Where | Licence / terms |
| --- | --- | --- | --- |
| MATLAB Image Processing Toolbox, `ssim` | Local SSIM map returned as the second output of `ssim(img1,img2)` | Installed by the user; not included here | Commercial MathWorks product, governed by the MathWorks Software License Agreement. Documentation: <https://www.mathworks.com/help/images/ref/ssim.html> |

`dssimMap.m` calls `ssim` unmodified and adds no wrapper or patch around it.

## Method credited, not code

| Work | Contribution | Link |
| --- | --- | --- |
| Z. Wang, A. C. Bovik, H. R. Sheikh, E. P. Simoncelli, "Image quality assessment: from error visibility to structural similarity," *IEEE TIP*, 13(4):600–612, 2004 | Definition of SSIM, and of DSSIM as its complement | <https://doi.org/10.1109/TIP.2003.819861> |
| T. Zhang, C. Li, J. Liao, Z. Huang, Z. Feng, "Open-Sourced Vessel Extraction Algorithm Using Structural Dissimilarity Mapping," *IEEE IUS*, 2025 | The DSSIM mapping pipeline released here | <https://doi.org/10.1109/IUS62464.2025.11201682> |

## Excluded material

The OCT dataset used in the paper (repeated B-scans of labial mucosa from a human volunteer) is not included. It is clinical/volunteer data collected under Research Ethics Committee approval at the University of Dundee and is not redistributable from this repository.
