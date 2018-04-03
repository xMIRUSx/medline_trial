<html>
    <head>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

        <script src="js/jquery.tablesorter.min.js"></script>
        <style type="text/css">@import "css/style_table.css";</style>

        <!-- applying GUI improvements -->
        <script>
            $( function() {
                $('.tablesorter').tablesorter();
                $('.datepicker').datepicker();
                $(".datepicker").datepicker( "option", "dateFormat", "M dd, yy");
            });
        </script>


        <!-- ajax submit -->
        <script>
            $(document).ready(function() {
                $("#filterForm").submit(function(event) {
                    event.preventDefault(); //prevent default action

                    var $form = $( this );
                    var servletUrl = $form.attr( 'action' );
                    var method = $form.attr( 'method' );

                    //get dates
                    var sLbDt = $( "#shipDtLb" ).datepicker( "getDate" );
                    var sUbDt = $( "#shipDtUb" ).datepicker( "getDate" );
                    var rLbDt = $( "#recDtLb" ).datepicker( "getDate" );
                    var rUbDt = $( "#recDtUb" ).datepicker( "getDate" );

                    //and turn them into strings
                    var sLb, sUb, rLb, rUb;
                    if(sLbDt != null)
                        sLb = sLbDt.getFullYear() + "-" + (sLbDt.getMonth()+1) + "-" + sLbDt.getDate();
                    if(sUbDt != null)
                        sUb = sUbDt.getFullYear() + "-" + (sUbDt.getMonth()+1) + "-" + sUbDt.getDate();
                    if(rLbDt != null)
                        rLb = rLbDt.getFullYear() + "-" + (rLbDt.getMonth()+1) + "-" + rLbDt.getDate();
                    if(rUbDt != null)
                        rUb = rUbDt.getFullYear() + "-" + (rUbDt.getMonth()+1) + "-" + rUbDt.getDate();


                    $.ajax({
                        url:servletUrl,
                        method: method,
                          data:{
                              partNum: $('#partNum').val(),
                              partName: $('#partName').val(),
                              vendor: $('#vendor').val(),
                              qty: $('#qty').val(),
                              shipDtLb: sLb,
                              shipDtUb: sUb,
                              recDtLb: rLb,
                              recDtUb: rUb,
                          },
                          success:function(data){
                            $('#resultTable tbody > tr').remove();
                             $.each(data, function(index, order) {
                                var $tr = $("<tr>").appendTo($("#resultTableBody"));
                                $tr.append($("<td>").text(order.partNum))
                                     .append($("<td>").text(order.partName))
                                     .append($("<td>").text(order.vendor))
                                     .append($("<td>").text(order.qnty))
                                     .append($("<td>").text(order.shipDt))
                                     .append($("<td>").text(order.receiveDt));
                             });
                             $('.tablesorter').trigger("update");
                          }
                    });

                });
            });
        </script>

    </head>
    <body>
        <form id="filterForm" action="/orders/getInfo" method="get">
            <table>
                <tr>
                    <th>Filter</th>
                </tr>

                <tr>
                    <td>PN</td>
                    <td><input type="text" maxlength="512" size="76" id="partNum"></td>
                </tr>

                <tr>
                    <td>Part Name</td>
                    <td><input type="text" maxlength="512" size="76" id="partName"></td>
                </tr>


                <tr>
                    <td>Vendor</td>
                    <td><input type="text" maxlength="512" size="76" id="vendor"></td>
                </tr>

                <tr>
                    <td>Qty</td>
                    <td><input type="text" maxlength="512" size="76" id="qty"></td>
                </tr>

                <tr>
                    <td>Shipped</td>
                    <td>
                        <label>after</label>
                        <input type="text" class="datepicker" id="shipDtLb">
                        <label>before</label>
                        <input type="text" class="datepicker" id="shipDtUb">
                    </td>
                </tr>

                <tr>
                    <td>Received</td>
                    <td>
                        <label>after</label>
                        <input type="text" class="datepicker" id="recDtLb">
                        <label>before</label>
                        <input type="text" class="datepicker" id="recDtUb">
                    </td>
                </tr>

            </table>

            <button type="submit" id="filterBtn">Filter</button>
        </form>

        <table id="resultTable" class="tablesorter">
            <thead>
                <tr>
                    <th>PN</th>
                    <th>Part Name</th>
                    <th>Vendor</th>
                    <th>Qty</th>
                    <th>Shipped</th>
                    <th>Received</th>
                </tr>
            </thead>
            <tbody id="resultTableBody">

            </tbody>
        </table>

    </body>
</html>
