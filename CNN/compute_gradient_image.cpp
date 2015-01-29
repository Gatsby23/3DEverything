#include <mex.h>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/highgui/highgui_c.h>
#include <opencv2/imgproc/imgproc.hpp>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* parse input matrix */
  char* filename = mxArrayToString(prhs[0]);

  cv::Mat cv_img;
  cv::Mat cv_img_origin = cv::imread(filename);
  if (!cv_img_origin.data) 
  {
    printf("Could not open or find file: %s\n", filename);
  }
  // cv::resize(cv_img_origin, cv_img, cv::Size(227, 227));
  cv_img = cv_img_origin;
printf("%s %d %d\n", filename, cv_img.rows, cv_img.cols);

  // compute sobel gradient
  /// Generate grad_x and grad_y
  cv::Mat grad_x, grad_y, grad;
  cv::Mat abs_grad_x, abs_grad_y;
  int scale = 1;
  int delta = 0;
  int ddepth = CV_16S;

  /// Gradient X
  cv::Sobel(cv_img, grad_x, ddepth, 1, 0, 3, scale, delta, cv::BORDER_DEFAULT );
  cv::convertScaleAbs( grad_x, abs_grad_x );

  /// Gradient Y
  cv::Sobel(cv_img, grad_y, ddepth, 0, 1, 3, scale, delta, cv::BORDER_DEFAULT );
  cv::convertScaleAbs( grad_y, abs_grad_y );

  /// Total Gradient (approximate)
  cv::addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad );
  cv_img = grad;

  /* prepare for output */
  plhs[0] = mxCreateDoubleMatrix(cv_img.cols, cv_img.rows, mxREAL);
  double *p = mxGetPr(plhs[0]);

  /* assign values */
  for (int h = 0; h < cv_img.rows; ++h) 
  {
    for (int w = 0; w < cv_img.cols; ++w)
    {
      *p = cv_img.at<uchar>(h, w);
      p++;
    }
  }
}
