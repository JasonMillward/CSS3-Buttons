<?php
/**
 * Simple config file for jCode Lab
 *
 *
 * Released under the MIT license
 *
 * @copyright  2012 jCode
 * @category   config
 * @version    $Id$
 * @author     Jason Millward <jason@jcode.me>
 * @license    http://opensource.org/licenses/MIT
 * @package    jCode Lab
 */

require_once( dirname( __FILE__ ) . '/../config.php' );

require_once( COMMON_PHP . '/jCode_Custom/jTPL.php' );

try {
    // New jTPL class
    $smarty  = new jTPL( TEMPLATE_DIR );
    $footers = array(
        '<script src="../assets/js/coffeeButtons.js"></script>',
        '<script>$(function() { $(".jbutton").jButton(); });</script>',
        '<script>',
        ' $(function() { ',
        '   $("#greenButton").jButton({buttonColour: "#195D04"});',
        '   $("#redButton").jButton({buttonColour: "#870F0F"});',
        '   $("#purpleButton").jButton({buttonColour: "#8C00C3"}); ',
        '   $("#miscButton").jButton({
                buttonColour: "#4F5560",
                buttonTextColour: "#C2C2C2",
                tabColour: "#3A29D5",
                tabTextColour: "#E5E5E5"
            }); ',
        ' });',
        '</script>'
    );

    $headers = array(  '<link href="http://lab.jcode.me/assets/less/coffeeButtons.less" type="text/less" rel="stylesheet/less">');

    $smarty->assign('footers',   $footers);
    $smarty->assign('headers',   $headers);

    // Display the page
    $smarty->display('header.tpl');
    $smarty->display('cssButtons/buttons.tpl');
    $smarty->display('footer.tpl');

} catch ( exception $e ) {
    die( $e->getMessage() );
}

?>

