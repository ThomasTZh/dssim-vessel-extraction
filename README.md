# DSSIM vessel extraction

MATLAB implementation of **structural dissimilarity (DSSIM) mapping**, which extracts blood-flow information from repeated, contrast-free structural scans.

[![DOI](https://img.shields.io/badge/DOI-10.1109%2FIUS62464.2025.11201682-blue)](https://doi.org/10.1109/IUS62464.2025.11201682)

## Abstract

Structural imaging such as MRI, CT, B-mode ultrasound, and OCT visualises tissue well but gives poor intrinsic contrast for blood vessels, so angiography normally requires injected contrast agents, angle-dependent Doppler processing, ionising radiation, or limited penetration depth. DSSIM mapping removes that requirement: from *N* repeated grayscale scans of the same location, it isolates the dynamic component (blood flow and minor bulk motion) by measuring how structurally dissimilar each frame is from the temporal reference. Static tissue yields high structural similarity and therefore low dissimilarity; moving scatterers yield the opposite. The output is a high-contrast flow map per B-scan that can be stacked into a three-dimensional microvasculature volume. This repository contains the single MATLAB function described in the paper and reproduced from its appendix.

## Methods and Materials

### Method

Each repeated image is modelled as the sum of a static component, a dynamic component, and noise:

```
img[i] = img_s + img_d + img_n,   i = 1 ... N
```

The temporal reference is the average of all repeats:

```
img_ref = (1/N) * sum_i img[i]
```

The local structural similarity between each frame and the reference is computed with the standard SSIM decomposition into luminance `l`, contrast `c`, and structure `s`, weighted by positive exponents `α`, `β`, `γ`:

```
SSIM_i(img_i, img_ref) = l(img_i, img_ref)^α · c(img_i, img_ref)^β · s(img_i, img_ref)^γ
```

Structural dissimilarity is the complement of SSIM, mapped to `[0, 1]` and then averaged over the repeats:

```
DSSIM_i = (1 - SSIM_i) / 2
DSSIM   = (1/N) * sum_i DSSIM_i
```

These equations are implemented by `dssimMap.m`:

```matlab
function [str,bld] = dssimMap(repImgs)
% repImgs: repeated images Z-X-N
% str: structural image
% bld: blood flow image
str=mean(repImgs,3);
ssimMap=zeros(size(repImgs));
for i=1:size(repImgs,3)
    [~,ssimMap(:,:,i)]=ssim(repImgs(:,:,i), str);
end
bld=mean(ssimMap,3);
bld=(1-bld)./2; % calculate DSSIM
end
```

The file is the appendix listing of [1], reproduced without modification.

### Requirements

| Component | Version | Notes |
| --- | --- | --- |
| MATLAB | Not specified in [1]; any release providing `ssim` | Written against the `ssim` signature `[ssimval,ssimmap] = ssim(img1,img2)` |
| Image Processing Toolbox | Any release providing `ssim` | Supplies `ssim`; not redistributed here, see [THIRD_PARTY.md](THIRD_PARTY.md) |

### Input and output

- `repImgs` — repeated grayscale images of one scanning location, as a 3-D array `Z × X × N`, where `Z` is the axial axis, `X` the lateral axis, and `N` the number of repeats. In [1] the acquisition was `384 × 400 × 400 × 4` (`Z × X × Y × N`) and the frames were flattened on the air–tissue junction and cropped to 96 pixels deep before DSSIM mapping.
- `str` — the structural image, `Z × X` (the temporal average).
- `bld` — the blood-flow map, `Z × X`, values in `[0, 0.5]`.

`N` must be at least 2 for the dissimilarity to carry information; the paper used `N = 4`.

### Usage

```matlab
% repImgs: Z-by-X-by-N array of repeated B-scans of the same location
[str, bld] = dssimMap(repImgs);

figure;
subplot(1,2,1); imagesc(str); axis image off; colormap gray; title('Structural');
subplot(1,2,2); imagesc(bld); axis image off; colormap gray; title('DSSIM (blood flow)');
```

Stacking `bld` over the `Y` positions of a 3-D acquisition produces the flow volume; the en-face view in [1] was rendered by maximum intensity projection with depth encoded as hue.

### Implementation notes

- `ssim` is called with default options, so the local window, stabilising constants, and exponents are the toolbox defaults; [1] introduces no custom SSIM parameters. See the [MATLAB `ssim` documentation](https://www.mathworks.com/help/images/ref/ssim.html).
- The second output of `ssim` is the local SSIM map; the scalar global value is discarded.
- `zeros(size(repImgs))` sizes the accumulator from the 3-D input, so `repImgs` must be a genuine 3-D array even when `N = 1`.

## Results

The paper reports a demonstration on a benign intraoral ulcer of a 25-year-old healthy volunteer, acquired with a lab-built swept-source OCT system: 3-D microvasculature maps with increased vessel density around the ulcer and intact deep vessels. That dataset is clinical/volunteer data and is **not** redistributed here, so the figures of [1] are not reproduced in this repository.

## Conclusion

`dssimMap.m` is the complete implementation of DSSIM mapping: a temporal-average reference, one local SSIM map per repeat, and the averaged complement of those maps. The method needs only repeated structural scans and no contrast agent. Its known limitation, stated in [1], is sensitivity to bulk motion between repeats, which faster acquisition protocols or motion correction would address; its behaviour on modalities beyond OCT has not yet been tested.


## Citation

```bibtex
@inproceedings{zhang2025dssim,
  title     = {Open-Sourced Vessel Extraction Algorithm Using Structural Dissimilarity Mapping},
  author    = {Zhang, Tianyu and Li, Chunhui and Liao, Jinpeng and Huang, Zhihong and Feng, Zhengshuyi},
  booktitle = {2025 IEEE International Ultrasonics Symposium (IUS)},
  year      = {2025},
  doi       = {10.1109/IUS62464.2025.11201682}
}
```

Machine-readable metadata is in [CITATION.cff](CITATION.cff).


## References

1. T. Zhang, C. Li, J. Liao, Z. Huang, and Z. Feng, "Open-Sourced Vessel Extraction Algorithm Using Structural Dissimilarity Mapping," in *2025 IEEE International Ultrasonics Symposium (IUS)*, 2025, doi: [10.1109/IUS62464.2025.11201682](https://doi.org/10.1109/IUS62464.2025.11201682).
2. Z. Wang, A. C. Bovik, H. R. Sheikh, and E. P. Simoncelli, "Image quality assessment: from error visibility to structural similarity," *IEEE Transactions on Image Processing*, vol. 13, no. 4, pp. 600–612, 2004, doi: [10.1109/TIP.2003.819861](https://doi.org/10.1109/TIP.2003.819861).
