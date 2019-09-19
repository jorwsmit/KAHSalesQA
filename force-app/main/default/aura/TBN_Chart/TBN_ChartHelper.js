({
	drawChart : function(component) {
        
		var chartTitle = component.get("v.chartTitle");
        var chartData = component.get("v.chartData");
        
        var hasChartData = true;
        var arr = new Array();

        for( var i=0 ; i<chartData.length ; i++ )  {
            
            if( chartData[i].value == 0 )
                arr.push(chartData[i].value);
        }
        
        if( chartData.length == arr.length )
            hasChartData = false;
        
        var segmentPercent = 0;
        
        // In case of Pie, Doughnut, PolarArea.
        if (chartData.length > 0 && chartData[0].value != null){
            
            var chartLegend = [];
          //  var colors = this.getDistributedColor(component, chartData.length, true);
			
            for (var i=0; i < chartData.length; i++){

                // If color is null, set it.
                chartData[i].legendLabel = chartData[i].legendLabel;
                if (chartData[i].color == null){
                    chartData[i].color = chartData[i].colorVal;
                }
                
                segmentPercent = segmentPercent+chartData[i].value;
                chartData[i].text= 'dsd';
                console.log('====text=2=1==',chartData[i].text);
                // If value is not set, exit.
                if (chartData[i].value == null){
                    console.error("Chart data is corrupted. Required property 'chartData[" + i + "].value' not found.");
                    return;
                }
                if(hasChartData){
                    // Set chart legend.
                    if (chartData[i].label != null && chartData[i].label != ""){
                        chartLegend.push({
                            label : chartData[i].legendLabel,
                            color : chartData[i].color,
                            amount : chartData[i].value
                        });
                    }
                }
            }
            
            component.set("v.chartLegend", chartLegend);
        }

        // If chart already exists, we destroy it first and re-create to clean the state.
        var chart = component.get("v.chart");
        if (chart != null){
            chart.destroy();
        }

        // Draw chart.
        var chartType = 'Pie'; 
        var globalId = component.getGlobalId();

        var	canvas = document.getElementById(globalId + "_chart");
        var ctx = canvas.getContext("2d");
	  
        if (hasChartData) {
            
            Chart.types.Pie.extend({
                name: "DoughnutAlt",
                draw: function () {

                    Chart.types.Pie.prototype.draw.apply(this, arguments);
                    var radius = this.outerRadius;
                    var midX = canvas.width/2;
                    var midY = canvas.height/2;
                    var textSize = "14";
                    for(var i=0; i<this.segments.length; i++) {

                        ctx.fillStyle="black";
                                                                
                        ctx.font= textSize+"px Verdana";
                        
                        // Get needed variables
                        var value = this.segments[i].value;
                        var startAngle = this.segments[i].startAngle;
                        var endAngle = this.segments[i].endAngle;
                        var middleAngle = startAngle + ((endAngle - startAngle)/2);
                        
                        // Compute text location
                        var posX = (radius/2) * Math.cos(middleAngle) + midX;
                        var posY = (radius/2) * Math.sin(middleAngle) + midY;
                        
                        // Text offside by middle
                        var w_offset = ctx.measureText(value).width/2;
                        var h_offset = textSize/4;
                        
                        
                        var segmentPercentageVal = (value * 100)/segmentPercent;
                        segmentPercentageVal = segmentPercentageVal.toFixed(1);
                        ctx.textAlign = "center"
                        ctx.textBaseline = "middle";
                        ctx.fillText(segmentPercentageVal+'%', (posX - w_offset), posY - h_offset);
                    }
                }
            });
            
            new Chart(ctx).DoughnutAlt(chartData, {
                percentageInnerCutout: 1, animationEasing: "easeOutQuart"
            });

        }
        else {
            
            ctx.font = "20px Verdana";
            ctx.textAlign = "left";
            ctx.textBaseline = "middle";
            ctx.fillStyle = "grey";
            ctx.fillText("No data in chart.", 100, 100);
        }
        
        
        // Save chart instance and chart data so that we can refer them afterward. 
        // Ex. Those properties are refered when chart type is changed.
        component.set("v.chart", chart);
        component.set("v.chartData", chartData);
   
    },
    showTooltip: function(t, i) {
        console.log('======hello===');
            "undefined" == typeof this.activeElements && (this.activeElements = []);
            var o = function(t) {
                var i = !1;
                return t.length !== this.activeElements.length ? i = !0 : (n(t, function(t, e) {
                    t !== this.activeElements[e] && (i = !0)
                }, this), i)
            }.call(this, t);
            if (o || i) {
                if (this.activeElements = t, this.draw(), this.options.customTooltips && this.options.customTooltips(!1), t.length > 0)
                    if (this.datasets && this.datasets.length > 1) {
                        for (var a, h, r = this.datasets.length - 1; r >= 0 && (a = this.datasets[r].points || this.datasets[r].bars || this.datasets[r].segments, h = l(a, t[0]), -1 === h); r--);
                        var c = [],
                            u = [],
                            d = function() {
                                var t, i, e, n, o, a = [],
                                    l = [],
                                    r = [];
                                return s.each(this.datasets, function(i) {
                                    t = i.points || i.bars || i.segments, t[h] && t[h].hasValue() && a.push(t[h])
                                }), s.each(a, function(t) {
                                    l.push(t.x), r.push(t.y), c.push(s.template(this.options.multiTooltipTemplate, t)), u.push({
                                        fill: t._saved.fillColor || t.fillColor,
                                        stroke: t._saved.strokeColor || t.strokeColor
                                    })
                                }, this), o = m(r), e = g(r), n = m(l), i = g(l), {
                                    x: n > this.chart.width / 2 ? n : i,
                                    y: (o + e) / 2
                                }
                            }.call(this, h);
                        new e.MultiTooltip({
                            x: d.x,
                            y: d.y,
                            xPadding: this.options.tooltipXPadding,
                            yPadding: this.options.tooltipYPadding,
                            xOffset: this.options.tooltipXOffset,
                            fillColor: this.options.tooltipFillColor,
                            textColor: this.options.tooltipFontColor,
                            fontFamily: this.options.tooltipFontFamily,
                            fontStyle: this.options.tooltipFontStyle,
                            fontSize: this.options.tooltipFontSize,
                            titleTextColor: this.options.tooltipTitleFontColor,
                            titleFontFamily: this.options.tooltipTitleFontFamily,
                            titleFontStyle: this.options.tooltipTitleFontStyle,
                            titleFontSize: this.options.tooltipTitleFontSize,
                            cornerRadius: this.options.tooltipCornerRadius,
                            labels: c,
                            legendColors: u,
                            legendColorBackground: this.options.multiTooltipKeyBackground,
                            title: t[0].label,
                            chart: this.chart,
                            ctx: this.chart.ctx,
                            custom: this.options.customTooltips
                        }).draw()
                    } else n(t, function(t) {
                        var i = t.tooltipPosition();
                        new e.Tooltip({
                            x: Math.round(i.x),
                            y: Math.round(i.y),
                            xPadding: this.options.tooltipXPadding,
                            yPadding: this.options.tooltipYPadding,
                            fillColor: this.options.tooltipFillColor,
                            textColor: this.options.tooltipFontColor,
                            fontFamily: this.options.tooltipFontFamily,
                            fontStyle: this.options.tooltipFontStyle,
                            fontSize: this.options.tooltipFontSize,
                            caretHeight: this.options.tooltipCaretSize,
                            cornerRadius: this.options.tooltipCornerRadius,
                            text: C(this.options.tooltipTemplate, t),
                            chart: this.chart,
                            custom: this.options.customTooltips
                        }).draw()
                    }, this);
                return this
            }
        },
    

    // Method to generate distributed colors for charts.
    // If chart data does not contain color or fillColor property, this method is called and try to set all colors automatically.
    getDistributedColor : function(component, input, thin) {
        
        var r = Math.floor(Math.random() * 200) + Math.floor(Math.random());
        var g = 0x0;
        var b = 0x0;
        var thin_plus = ( thin )? 1:0;
        var colors_array = new Array();
        
        for( var i=0 ; ; i++ ) {
            
            if( Math.pow(i,3) >= input ) {
                
                var max = i - 1 + thin_plus;
                break;
            }
        }
        
        var _plus = 0xff / max;
        for( var i=thin_plus ; i<=max ; i++ ) {
            
            r = Math.floor(Math.random() * 200) + Math.floor(Math.random());
            g = 0x0;
            b = 0x0;
            
            for( var j=thin_plus ; j<=max ; j++ ) {
                
                g = _plus * j;
                b = 0x0;
                
                for( var k=thin_plus ; k<=max ; k++ ) {
                    
                    b = _plus * k;
                    colors_array.push( [ Math.round(r) , Math.round(g) , Math.round(b) ] );
                    if( colors_array.length >= input )return colors_array;
                }
                
                if( colors_array.length >= input ) return colors_array;
            }
            
            if( colors_array.length >= input ) return colors_array;
        }
    }
})