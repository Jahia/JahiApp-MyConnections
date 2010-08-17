<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<template:addResources type="css" resources="social.css"/>
<template:addResources type="css" resources="jquery.fancybox.css"/>
<template:addResources type="javascript" resources="jquery.min.js,jquery.cuteTime.js"/>
<template:addResources type="javascript" resources="jquery.fancybox.pack.js"/>
<template:addResources type="javascript" resources="jahia.social.js"/>

<script type="text/javascript">

    function tabCallback() {
        $(".messageDetailLink").click(function() {
            $.ajax({
                url: $(this).attr('rel'),
                type : 'get',
                success : function (data) {
                    $(".social-message-detail").html(data);
                    $('.timestamp').cuteTime({ refresh: 60000 });
                    initActionDeleteLinks($("div.social-message-detail a.messageActionDelete"));
                    initShowSendMessage($("div.social-message-detail a.messageActionReply"));
                }
            });
        });

        $('.timestamp').cuteTime({ refresh: 60000 });
        
        $("#sendMessage").submit(function() {
            if ($("#messagesubject").val().length < 1) {
                $("#login_error").show();
                $.fancybox.resize();
                return false;
            }

            $.fancybox.showActivity();
            $.ajax({
                type        : "POST",
                cache       : false,
                url         : '${url.base}${currentNode.path}.sendmessage.do',
                data        : $(this).serializeArray(),
                success     : function(data) {
                    alert("<fmt:message key='message.messageSent'/>");
                    $.fancybox.resize();
                    $.fancybox.center();
                    $.fancybox.close();
                }
            });

            return false;
        });
        
        initActionDeleteLinks($("a.messageActionDelete"));
        initShowSendMessage($("a.messageActionReply"));
    }
    function initActionDeleteLinks(links) {
        links.click(function(e){
            e.preventDefault();
            var msgId = $(this).attr('rel');
            if (confirm("<fmt:message key='message.removeSocialMessage.confirm'/>")) {
                removeSocialMessage('${url.base}/${currentNode.path}', msgId,
                    function() {
                        $("#social-message-" + msgId).remove();
                        if ($("div.social-message-detail div#social-message-detail-" + msgId).length > 0) {
                     	  $(".social-message-detail").empty();
                        }
                    });
            }
        });
    }
    function initShowSendMessage(links) {
        links.fancybox({
            'scrolling'          : 'no',
            'titleShow'          : false,
            'hideOnContentClick' : false,
            'showCloseButton'    : true,
            'overlayOpacity'     : 0.6,
            'transitionIn'       : 'none',
            'transitionOut'      : 'none',
            'centerOnScroll'     : true,
            'onStart'            : function(selectedArray, selectedIndex, selectedOpts) {
                var info = $(selectedArray).attr('rel');
                if (info.indexOf('details-') == 0) {
                    info = info.substring('details-'.length);
                }
                var userKey = info.split('|')[0];
                $('#destinationUserKey').val(userKey);
                $('#messagesubject').val("<fmt:message key='label.replySubject'/>" + " " + info.substring(userKey.length + 1));
                $('#messagebody').val('');
            }, 
            'onClosed'           : function() {
                $("#login_error").hide();
            }
        });
    }
    <c:if test="${not renderContext.ajaxRequest}">
    $(document).ready(function() {
        tabCallback();
    });
    </c:if>
</script>
<c:if test="${renderContext.ajaxRequest}">
    <template:addResources type="inlinejavascript">
        tabCallback();
    </template:addResources>
</c:if>

<div class='grid_8 alpha'><!--start grid_8-->

    <jcr:sql var="receivedMessages"
             sql="select * from [jnt:socialMessage] where isdescendantnode(['${currentNode.path}/messages/inbox']) order by [jcr:lastModified] desc"/>

    <h3 class="social-title-icon titleIcon"><fmt:message key="receivedMessages"/><img title="" alt=""
                                                                                    src="${url.currentModule}/images/mailbox.png"/>
    </h3>
<div class="boxsocial"><!--start boxsocial -->
    <div class=" boxsocialmarginbottom16">
        <div class="boxsocial-inner">
            <div class="boxsocial-inner-border">
                <ul class="userMessagesList">
                    <c:forEach items="${receivedMessages.nodes}" var="userMessage">
                        <li id="social-message-${userMessage.identifier}">
                            <template:module path="${userMessage.path}" />
                        </li>
                    </c:forEach>
                </ul>
			</div>
		</div>
	</div>
	<div class='clear'></div>
</div>

</div><!--stop grid_18-->
<div class='grid_8 omega'><!--start grid_8-->

    <div id="socialMessageDetail" class="social-message-detail">
        
    </div>

    <div class='clear'></div>

</div>
<!--stop grid_8-->

<div class='clear'></div>

<div id="divSendMessage">
    <div class="popup-bodywrapper">
        <h3 class="boxmessage-title"><fmt:message key="message.new"/></h3>

        <form class="formMessage" id="sendMessage" method="post" action="">
            <input type="hidden" name="j:to" id="destinationUserKey" value="" />
            <fieldset>
                <legend><fmt:message key="message.label.creation"/></legend>
                <p id="login_error" style="display:none;"><fmt:message key="message.enterData"/></p>

                <p><label for="messagesubject" class="left"><fmt:message key="message.label.subject"/></label>
                    <input type="text" name="j:subject" id="messagesubject" class="field" value=""
                           tabindex="20"/></p>


                <p><label for="messagebody" class="left"><fmt:message
                        key="message.label.body"/> :</label>
                    <textarea name="j:body" id="messagebody" cols="45" rows="3"
                              tabindex="21"></textarea></p>
                <input class="button" type="button" value="<fmt:message key="message.label.send"/>"
                       tabindex="28"
                       id="messagesendbutton" onclick="$('#sendMessage').submit();">
            </fieldset>
        </form>
    </div>
</div>

