/********************************
#################################################
# 二元正态分布 Bivariate Normal Distribution
# MCM2018 C++代码模板 SJTU    
# By:徐佳怡
#################################################
# 使用说明
# 1、输入：在运行窗口输入数据点个数以及每一个数据点横纵坐标（x,y）
#    示例：2
#          1 1
#          2 2
# 2、输出：输出结果为二元正态分布的五个参数：横坐标均值，横坐标方差，纵坐标均值，纵坐标方差，横纵坐标相关系数
#################################################
****/
#include <vector>
#include <iostream>
#include <cstdio>
#include <assert.h>
#include <ctime>
#include <cmath>
using namespace std;

****************************/

//点类
struct Vertex
{
	int x;
	int y;
};
Vertex ver[107];//修改数组容量


int main()
{
    int n;
    double ex(0),ey(0),exy(0),dx(0),dy(0),dxy(0),p;
    cin>>n;
    for(int i=0;i<n;++i)
        cin>>ver[i].x>>ver[i].y;
    for(int i=0;i<n;++i)
    {
        ex+=ver[i].x;
        ey+=ver[i].y;
        exy+=(ver[i].x*ver[i].y);
    }
    ex=ex/n;
    ey=ey/n;
    exy=exy/n;
    for(int i=0;i<n;++i)
    {
        dx+=(ver[i].x-ex)*(ver[i].x-ex);
        dy+=(ver[i].y-ey)*(ver[i].y-ey);
    }
    dx=dx/n;
    dy=dy/n;
    p=(exy-ex*ey)/(sqrt(dx)*sqrt(dy));

    cout<<ex<<' '<<dx<<' '<<ey<<' '<<dy<<' '<<p;

    return 0;
}
