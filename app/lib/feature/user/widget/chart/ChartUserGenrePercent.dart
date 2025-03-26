import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartUserGenrePercent extends StatelessWidget {
  const ChartUserGenrePercent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25, Color.fromRGBO(9,0,136,1)),
      ChartData('Steve', 38, Color.fromRGBO(147,0,119,1)),
      ChartData('Jack', 34, Color.fromRGBO(228,0,124,1)),
      ChartData('Others', 52, Color.fromRGBO(255,189,57,1))
    ];

    return Scaffold(
        body: Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: mainBlack
              ),
              child: SfCircularChart(
                annotations: <CircularChartAnnotation>[
                  // 상단에 "Total Value" 표시
                  CircularChartAnnotation(
                    widget: RichText(
                      textAlign: TextAlign.center, // 텍스트 중앙 정렬
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Total Value\n', // 첫 번째 줄
                            style: TextStyle(
                              color: mainGrey,
                              fontSize: 20,
                              fontFamily: 'PretendardSemiBold',
                            ),
                          ),
                          TextSpan(
                            text: '75', // 두 번째 줄 (다른 스타일 적용)
                            style: TextStyle(
                              color: mainWhite,
                              fontSize: 32,
                              fontFamily: 'PretendardBold',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    innerRadius: '70%',
                    strokeColor: mainWhite,
                    strokeWidth: 1,
                  ),
                ],
              ),
            )
        )
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
