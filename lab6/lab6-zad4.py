# source of idea: https://theailearner.com/tag/nearest-neighbor-interpolation/

import cv2
import numpy as np

picture = cv2.imread('sarajevo-small.jpg')

near_picture = cv2.resize(picture, None, fx = 10, fy = 10, interpolation = cv2.INTER_NEAREST)
cv2.imwrite('1-sarajevo-nearest.jpg', near_picture)

bilinear_picture = cv2.resize(picture, None, fx = 10, fy = 10, interpolation = cv2.INTER_LINEAR)
cv2.imwrite('2-sarajevo-bilinear.jpg', bilinear_picture)

bicubic_picture = cv2.resize(picture, None, fx = 10, fy = 10, interpolation = cv2.INTER_CUBIC)
cv2.imwrite('3-sarajevo-bicubic.jpg', bicubic_picture)

lanczos4_picture = cv2.resize(picture, None, fx = 10, fy = 10, interpolation = cv2.INTER_LANCZOS4)
cv2.imwrite('4-sarajevo-lanczos4.jpg', lanczos4_picture)
