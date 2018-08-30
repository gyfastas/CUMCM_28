/********************************
#################################################
# 二元均匀分布Bivariate Uniform Distribution
# MCM2018 C++代码模板 SJTU
# By: 徐佳怡
#################################################
# 使用说明：
# 1、输入：在运行窗口输入数据点个数以及每一个数据点横纵坐标
#    示例：3
#          0 0
#          1 2
#          3 5
# 2、输出：输出结果为二元均匀分布的密度
#################################################
********************************/

#include <iostream>
#include <iomanip>
#include <algorithm>
using namespace std;

//点类
struct Vertex
{
	int x;
	int y;
};
Vertex ver[107];//修改数组容量

//根据叉积排序极角，当极角相等时距离远的点在前面，方便后面删除极角一样的点
bool cmp(Vertex ver1, Vertex ver2)
{
	int x1,x2,y1,y2,s;
	x1 = ver1.x-ver[0].x;
	y1 = ver1.y-ver[0].y;
	x2 = ver2.x-ver[0].x;
	y2 = ver2.y-ver[0].y;
	s = x1*y2 - x2*y1;
	if(s>0 || s==0 && x1*x1+y1*y1>x2*x2+y2*y2)
		return true;
	else
		return false;
}

//线段拐向的判断
//若(p2 - p0) × (p1 - p0) > 0,则p0p1在p1点拐向右侧后得到p1p2。
//若(p2 - p0) × (p1 - p0) < 0,则p0p1在p1点拐向左侧后得到p1p2。
//若(p2 - p0) × (p1 - p0) = 0,则p0、p1、p2三点共线
inline int dig(int x0, int y0, int x1, int y1, int x2, int y2)
{
	return (x2 - x0) * (y1 - y0) - (y2 - y0) * (x1 - x0);
}

//交换
void Swap(Vertex &ver1, Vertex &ver2)
{
	Vertex temp;
	temp.x = ver1.x;
	temp.y = ver1.y;
	ver1.x = ver2.x;
	ver1.y = ver2.y;
	ver2.x = temp.x;
	ver2.y = temp.y;
}

int main()
{
	double s,m,D;
	int p,n,i,j,k,a,b;
	int StackVer[107];
	int pVer;
	int MinY;

    cin>>n;
    for (i=0; i<n; i++)
        cin>>ver[i].x>>ver[i].y;
    if(n<=2)
    {
       return 0;
    }
    s=0;
    pVer=0;
    MinY = 0;
    for (i=1; i<n; i++)
    {
        if (ver[i].y<ver[MinY].y || ver[i].y==ver[MinY].y&&ver[i].x<ver[MinY].x)
        {
            MinY = i;
        }
    }

    Swap(ver[0],ver[MinY]);
    sort(ver+1,ver+n, cmp);
    k=2;
    //删除重复的点
    for(i=2; i<n; i++)
    {
        if(dig(ver[0].x, ver[0].y, ver[i-1].x,ver[i-1].y, ver[i].x, ver[i].y) != 0)
				ver[k++] = ver[i];
    }
    //堆栈初始化
    StackVer[pVer++] = 0;
    StackVer[pVer++] = 1;
    StackVer[pVer++] = 2;

    //找到所有极点
    for(i = 3; i < k; i++)
    {
        for(a = StackVer[pVer - 2], b = StackVer[pVer - 1];! (dig(ver[a].x, ver[a].y, ver[b].x, ver[b].y, ver[i].x, ver[i].y)< 0);a = StackVer[pVer - 2], b = StackVer[pVer - 1])
            {
                pVer--;   //删点
            }
            StackVer[pVer++] = i;  //加点
    }

		//计算面积s
		while(pVer>=2)
		{
			a = StackVer[pVer - 2];
			b = StackVer[pVer - 1];
			m = dig( ver[0].x, ver[0].y,ver[b].x, ver[b].y,ver[a].x, ver[a].y)/2.0;
			if(m<0) m=-m;
			pVer--;
			s=s+m;
		}
		//计算概率密度D

		D=1/s;
		cout<<setiosflags(ios::fixed)<<setprecision(1)<<D<<endl;

	return 0;
}
