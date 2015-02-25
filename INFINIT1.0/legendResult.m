% Legend
FontSize = 10;
MarkerSize = 5;
BaseLat = 33.0;
BaseLon = 52.0;
SpacingLat = 0.5;
SpacingLon = 0.7;

textm(BaseLat+0.2,BaseLon-0.6,'Optimized for 2030 Demand','Color','k','FontSize',FontSize+1,'FontWeight','bold','FontName','Calibri');
geoshow(BaseLat-1*SpacingLat,BaseLon,'DisplayType','multipoint',...
                            'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','g',...
                            'MarkerSize',MarkerSize);
textm(BaseLat-1*SpacingLat,BaseLon+SpacingLon,'City w/ WWT','Color','k','FontSize',FontSize,'FontName','Calibri');
geoshow(BaseLat-2*SpacingLat,BaseLon,'DisplayType','multipoint',...
                            'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','r',...
                            'MarkerSize',MarkerSize);
textm(BaseLat-2*SpacingLat,BaseLon+SpacingLon,'City w/o WWT','Color','k','FontSize',FontSize,'FontName','Calibri');
geoshow(BaseLat-3*SpacingLat,BaseLon,'DisplayType','multipoint',...
                            'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','b',...
                            'MarkerSize',MarkerSize);
textm(BaseLat-3*SpacingLat,BaseLon+SpacingLon,'Desal plant','Color','k','FontSize',FontSize,'FontName','Calibri');
geoshow(BaseLat-4*SpacingLat,BaseLon,'DisplayType','multipoint',...
                            'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','y',...
                            'MarkerSize',MarkerSize);
textm(BaseLat-4*SpacingLat,BaseLon+SpacingLon,'Power plant','Color','k','FontSize',FontSize,'FontName','Calibri');
geoshow([BaseLat-5*SpacingLat BaseLat-5*SpacingLat],[BaseLon-0.5 BaseLon+0.5],'LineWidth',2,'Color',[0 0 0.7]);
textm(BaseLat-5*SpacingLat,BaseLon+SpacingLon,'Water pipeline (in use)','Color','k','FontSize',FontSize,'FontName','Calibri');
geoshow([BaseLat-6*SpacingLat BaseLat-6*SpacingLat],[BaseLon-0.5 BaseLon+0.5],'LineWidth',2,'Color',[0 0.7 1]);
textm(BaseLat-6*SpacingLat,BaseLon+SpacingLon,'Water pipeline (new)','Color','k','FontSize',FontSize,'FontName','Calibri');
geoshow([BaseLat-7*SpacingLat BaseLat-7*SpacingLat],[BaseLon-0.5 BaseLon+0.5],'LineWidth',1.5,'Color','r');
textm(BaseLat-7*SpacingLat,BaseLon+SpacingLon,'Water pipeline (not in use)','Color','k','FontSize',FontSize,'FontName','Calibri');
