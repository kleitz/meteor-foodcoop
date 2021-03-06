/* globals $ */
import angular from 'angular';
import './style.css';


const name = 'percentDisplay';


export default angular.module(name, []).directive(name, function () {
  return {
    restrict: 'E',
    template: '<div class="ngpercentdisplay" data-percent="{{ percent }}">' +
                        '<div class="ngperdispleft">' +
                            '<span></span>' +
                        '</div>' +
                        '<div class="ngperdispright">' +
                            '<span></span>' +
                       '</div>' +
                    '</div>',
    scope: { percent: '=' },
    link: ($scope, element, attrs) => {
      const jEle = $(element);
      const leftSide = jEle.find('.ngperdispleft span');
      const rightSide = jEle.find('.ngperdispright span');
      const side = attrs.side || 50;
      const fontSize = Math.floor(side / 5);
      const colors = attrs.colors.split(' ');
      let deg;
      let strdeg;

      if (!colors[0]) { colors[0] = '#DADADA'; }
      if (!colors[1]) { colors[1] = '#606060'; }
      if (!colors[2]) { colors[2] = '#FFFFFF'; }

      jEle
      .find('.ngpercentdisplay')
      .css({
        'width': side,
        'height': side,
        'font-size': fontSize,
        'background-color': colors[0],
        'color': colors[1],
      });
      jEle.find('.ngpercentdisplay span').css({ 'background-color': colors[1] });
      jEle.find('.ngpercentdisplay:before').css({ 'background-color': colors[2] });

      $scope.$watch('percent', (newvalue) => {
        if (newvalue > -1 && newvalue < 101) {
          if (newvalue <= 50) {
                        // Hide left
            leftSide.hide();

                        // Adjust right
            deg = 180 - (newvalue / 100 * 360);
            strdeg = 'rotateZ(-' + deg + 'deg)';
            rightSide
            .css({
              'transform': strdeg,
              '-webkit-transform': strdeg,
              '-moz-transform': strdeg,
              'msTransform': `rotate(-${deg}deg)`,
            });
          } else {
                        // Adjust left
            leftSide.show();
            deg = 180 - ((newvalue - 50) / 100 * 360);
            strdeg = `rotate(-${deg}deg)`;
            leftSide.css({
              'transform': strdeg,
              '-webkit-transform': strdeg,
              '-moz-transform': strdeg,
              'msTransform': `rotate(-${deg}deg)`,
            });
            rightSide.css({
              'transform': 'rotateZ(0deg)',
              '-webkit-transform': 'rotateZ(0deg)',
              '-moz-transform': 'rotateZ(0deg)',
              'msTransform': 'rotate(0deg)',
            });
          }
        }
      });
    },
  };
});
