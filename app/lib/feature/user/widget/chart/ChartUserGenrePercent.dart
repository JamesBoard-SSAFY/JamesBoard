import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartUserGenrePercent extends StatelessWidget {
  final List<ChartData> chartData; // chartData를 인자로 받음

  const ChartUserGenrePercent({super.key, required this.chartData});
  @override
  Widget build(BuildContext context) {
    int totalCount = chartData.fold(0, (sum, data) => sum + data.count);
    String totalCountString = totalCount.toString();

    return Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(color: mainBlack),
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
                        text: totalCountString,
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
              DoughnutSeries<ChartData, String>( // 원형 차트 데이터
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
        ));

  }
}

class ChartData {
  ChartData(this.x, this.y, this.color, this.count);

  final String x;
  final double y;
  final Color color;
  final int count;
}
