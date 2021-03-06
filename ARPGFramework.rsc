�    �X�=36�])6�]�  Demo\DemoInterface.dmf macro "macro"
	elem 
		name = "F+REP"
	elem 
		name = "Any"
		command = "KeyDown [[*]]"
	elem 
		name = "Any+UP"
		command = "KeyUp [[*]]"


menu "menu"
	elem 
		name = "&File"
		command = ""
		saved-params = "is-checked"
	elem 
		name = "&Quit"
		command = ".quit"
		category = "&File"
		saved-params = "is-checked"


window "window1"
	elem "window1"
		type = MAIN
		pos = 372,0
		size = 1306x757
		anchor1 = none
		anchor2 = none
		is-default = true
		saved-params = "pos;size;is-minimized;is-maximized"
		title = "ARPG Framework"
		statusbar = false
		macro = "macro"
	elem "browser1"
		type = BROWSER
		pos = 0,0
		size = 1306x757
		anchor1 = 0,0
		anchor2 = 100,100
		is-default = true
		saved-params = ""
	elem "map1"
		type = MAP
		pos = 0,0
		size = 1306x757
		anchor1 = 0,0
		anchor2 = 100,100
		is-default = true
		saved-params = "zoom;letterbox;zoom-mode"
		icon-size = 32
		zoom = 1

window "outputwindow"
	elem "outputwindow"
		type = MAIN
		pos = 1249,663
		size = 640x309
		anchor1 = none
		anchor2 = none
		background-color = none
		saved-params = "pos;size;is-minimized;is-maximized"
		title = "Output"
		statusbar = false
		can-close = false
		can-minimize = false
		can-resize = false
		outer-size = 658x355
		inner-size = 640x309
	elem "output1"
		type = OUTPUT
		pos = 0,0
		size = 640x316
		anchor1 = 0,0
		anchor2 = 100,85
		is-default = true
		saved-params = "max-lines"

s = "max-lines"

�   �<Ξ�K?^�K?^�  mapbrowser.html <HTML>
    <BODY>
    </BODY>
    <SCRIPT type="text/javascript"> //defines the script type
    var map_width; //declares the map_width var
    var map_height; //declares the map_height var
    var TILE_WIDTH = 32; //declares the tile_width var
    var TILE_HEIGHT = 32; //declares the tile_height var
    var MAX_VIEW_TILES = 800; //declares the maximum amount of tiles that can be in the viewport

    function CallVerb() {//defines a function to call a verb in BYOND's dreamseeker
        var locstr = "byond://winset?command=" + arguments[0];//assign the static part of the byond URL command to the variable locstr and append the first value in the arguments array onto it
        //(N.B. - the arguments object contains an array of the arguments used when the function was called)
        for(var count=1;count<arguments.length;count++) {//for every value in the arguments array except the first one
            locstr += " " + encodeURIComponent(arguments[count]);//append the value onto the locstr var
        }
        window.location = locstr;//set window.location to locstr to execute the byond command
    }

    function WinSet() {//defines a function to call the winset command in BYOND's dreamseeker
        var locstr = "byond://winset?id=" + arguments[0];//assign the static part of the byond URL command to the variable locstr and append the first value in the arguments array onto it
        for(var count=1;count<arguments.length;count+=2) {//for every other two values in the arguments array except the first one
            locstr += "&" + arguments[count] + "=" + arguments[count+1];//append the value onto the locstr val
        }  
        window.location = locstr;//set window.location to locstr to execute the byond command
    }

    function Output() {//defines a function to call the output command in BYOND's dreamseeker
        window.location = "byond://winset?command=.output " + arguments[0] + " " + encodeURIComponent(arguments[1]);//set window.location to the command to execute the output operation
    }

    window.onresize = function() {//function for when the window is resized
        var body = document.getElementsByTagName('body')[0];//get a reference to the element with the tag body in the document and assign it to the body var
        map_width = body.clientWidth;//set the map_width var to body.clientWidth
        map_height = body.clientHeight;//set the map_height var to body.clientHeight

        var map_zoom = 1;//declare the current map zoom as 1

        var view_width = Math.ceil(map_width/TILE_WIDTH);//set view_width to the ceil (rounded up) value of the result of (map_width/TILE_WIDTH)
        if(!(view_width%2)) ++view_width;//if view_width is an even number add one, this is necessary because if the view values are not odd numbers then it will be impossible for the client character to be centered on the screen
        var view_height = Math.ceil(map_height/TILE_HEIGHT);//set view_height to the ceil value of the result of (map_height/TILE_HEIGHT)
        if(!(view_height%2)) ++view_height;//if view_height is an even number add one

        while(view_width*view_height>MAX_VIEW_TILES) {//while the total amount of tiles visible is greateer than the total amount of allowed tiles in a viewport
            view_width = Math.ceil(map_width/TILE_WIDTH/++map_zoom);//set view_width to the ceil value of the result of (map_width/TILE_WIDTH/++map_zoom) (N.B. - ((map_width/TILE_WIDTH)/++map_zoom)  ) N.B. - ++map_zoom is used here instead of map_zoom++ to make sure that the map_zoom is not only incremented by 1 for future usage, but also so that the incrementation happens before the calculation is carried out
            if(!(view_width%2)) ++view_width;//if it is even, increment it by one to make it odd
            view_height = Math.ceil(map_height/TILE_HEIGHT/map_zoom);//set view_height to the ceil value of the result of (height/TILE_HEIGHT/map_zoom)
            if(!(view_height%2)) ++view_height;//if view_height is even, make it odd
        }

        var buffer_x = Math.floor((view_width*TILE_WIDTH - map_width/map_zoom)/2);//set the buffer_x value to the floor (rounded down) value of the result of ((view_width*TILE_WIDTH - map_width/map_zoom)/2)
        var buffer_y = Math.floor((view_height*TILE_HEIGHT - map_height/map_zoom)/2);//set the buffer_y value to the floor value of the result of ((view_height*TILE_HEIGHT - map_height/map_zoom)/2)
        WinSet("map1","zoom",map_zoom);//call the WinSet function to invoke the winset function in BYOND's dreamseeker, to set the zoom value of the map

        CallVerb("onResize",view_width,view_height,buffer_x,buffer_y,map_zoom);//call the client.onResize verb and pass the appropriate vars into it as arguments
    };

    window.onload = function() {//when the window first loads
        CallVerb("onLoad");//call the client.onLoad() verb
    };

    var isfullscreen = 0;//declare a flag for whether or not the game is in fullscreen mode

    function ToggleFullscreen() {//function for toggle fullscreen on or off
        if(isfullscreen) {//if it is on, toggle it off
            WinSet("window1","titlebar","true","is-maximized","false","can-resize","true");//by calling the WinSet function to pass the appropriate command string argument (enabling the titlebar, unmaximizing the window and enabling manual resizing of the window) into the winset() BYOND procedure
            isfullscreen = 0;//disable the fullscreen flag
        } else {//if it is off, toggle it on
            WinSet("window1","titlebar","false")//call the winset function to remove the titlebar
            WinSet("window1","is-maximized","false");
            WinSet("window1","is-maximized","true","can-resize","false");//then call it again to maximize the window and disable manual resizing of it
            isfullscreen = 1;//enable the fullscreen flag
        }
    }

    var resolution_x;//declare a variable for the resolution along the x axis of the client screen
    var resolution_y;//declare a variable for the resolution along the y axis of the client screen

    function CenterWindow() {//function to center the window on the client screen
        window.location = "byond://winget?callback=CenterWindowCallback&id=window1&property=size";//assign the byond command to the window.location that will use the winget() command to callback the CenterWindowCallback() function and pass the window size values into it
    }

    function CenterWindowCallback(properties) {
        var win_width = properties.size.x;//set win_width to the x value of the window size
        var win_height = properties.size.y;//set win_height to the y value of the window size
        resolution_x = screen.width;//set resolution_x to the width of the screen
        resolution_y = screen.height;//set resolution_y to the height of the screen
        WinSet("default","pos",Math.floor((resolution_x-win_width)/2) + "," + Math.floor((resolution_y-win_height)/2));//call the WinSet function to invoke the winset() BYOND procedure and pass into it a string created by appending the floor values of ((resolution_x-win_width)/2) and ((resolution_y-win_height)/2) separated by a comma
    }
    </SCRIPT>
</HTML>  2G�g���]���]�  Base.dmi �PNG

   IHDR   �   �   1|�   PLTE������ �� �� f� �����bۮ   tRNS @��f   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S)3%'U��3%���5��L+J�M����s��L�+**�#�&%�8������Լ��JIūNY���$ j�N�I9�   �IDATh����@C���v�����[���A��I��w[�;A�	)	!Ľx,���\w�h]��d���	 `V@���	h�	Z�
��ے�A��ݯ0����uzv����!�?����+fe�l4�(h��y���t�f���f�~�~ ��G?�Ô�pNۊ~`�0����ь��!�D�s i�<p!�ޝ�@��.��@c?�p���8�xA�����4n����/�M��k���    IEND�B`�&  Y�t����]��]  Base2.dmi �PNG

   IHDR         �\�U   'PLTE���%$�c3��R����٦�1(&���wSS�ћ�P������   tRNS @��f   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S)3%'U��3%�����3�(17�NI�I�2�Ltu���<1'��6C=s$��]T�GX�"4�$g`ׅ�(�895/�̐X�SIӨ����p R}d�)�  �IDATx��]�n�6%���W�o��WG\�'����뢧���~@��?ء�D3TB�u3�}�f2"��#�UJLL�ъb��E.�_�U��x��u���5q|7�^�|�����>������W�w�]E1z%s�����
4j���{~�����኷ի�\��n��|`X�1n�  �����2�����O�v�NX��E�\5e[�����a��_���z��n&l��鉲9�M9��W{2[��_��/��^ �+��������l}	0a���?�7��7�4��~�K�o��^��+���7���! ��j��m�'�M�n������ݒ��ږb\d���|Hq�RlC���#���W��|����p����+r���`ɸ�I{�\p����\��P{���1�_�P���E5�2�{�믪cwӢN�F��p��S��p�!A�����3���|$]���m��We��@�����,��Fw�Jm�����J�T�J��hڂ\1111�D}@��"�~}���/�{;����>PCN���������^X(��΢�> �����> &&v�ƥ�� \z����\}�KϹ����MϹ���`yz��2�97 w��~�������g�n���\g�s&��{�v����='o���L~o�s��9X�Q*��L~���s4lK_Ŏ�H�	�9��k�?߈�yzޒ�e��@aa�����\j�P��H���L~_v7nr�:����n���@{����9^"�:��AM>,�@�E���!���什>���}�0���-��T����C�>��4@�
��z}@��D}@��<���> ��!�������(�z,�	/��<
��������D5@8@9��Z��m����B"6dnCz��1׶�ܒ�TM皉�h�jJ�#�zz�)�����=*���$���H
�>�>����֑L�_���()݇Y�?4.����h�``�>�]���i
�2������ݞ0v�wE^`��Џ?�z}@��D}@����9? �������bbb���> �����> ���������r~@��X���}K��8f��$���t��\������Ng��]�H����p:COG)9%��Bnc8�a�_�H����p2C}��䓇o�)r���a��䡝Gd��r��u�/h�O�U����� �}�]�/N�sX����{O��eu.N�sm��)�Q�ޚ��U��37�N��Iz��jl�N�xc�=�q��p��HN�se*kx�曵{2���m&N�sU65����5$�y���C~��PV���ŗ��/<�'䫴���f�g!{�m&~�h�o�C%�xT�9Ac��'����ė��s������'�#:P�=n7#��2��������f��O	B�!63r����t���s�g��j=Q\f�6��{8�C!�_�	���Q�f�{���z$���o��aF7�3q����f�>���zDz�<�U��C���S�EL�*?����X'|A `[���ټ������ή_��_��&�U8��V8��V8��V8��V8�=��>���	��<̷�>������>м��>0��\̷���"��m�;�O��1��`ɰ��lc�L���D��l+��>f[�����	0~\��k(<[@�{��|����s    IEND�B`�$  ������]���]
  Box2.dmi �PNG

   IHDR   �   `   ���   	PLTE�����3�3 Q�m�   tRNS @��f   szTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r�L�83R3�3J�K3��ĒT SI��3%���4��L+J�M���

rK��rq)TVp�s[ �i$&��0   0IDATH��˱  �@�dI��z��ԗ�2  V�1   |' `'���&����    IEND�B`�_  Y���BT^BT^@  BuildBox.dmi �PNG

   IHDR   �   `   'Tgz   PLTE   �3 � �f ��  ��3��Fv   tRNS @��f   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S�$�@��3%���3��L+J�M���j�3SR	*dD�I�U�TaHPa[�	�0!ߥ�
�~.� �m!����   IIDATX���1  ���,`��BC���z�D#�ъ
     @;`G�      �~@C��
     @7�3o�.-u��    IEND�B`���  �n��n\^�n\^�   MapShadow.dmi �PNG

   IHDR           I��   PLTE   �z=�   dzTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT SI��3%���4��L+J�M���\�\�& ��}��C   IDAT�c`�   � �O�    IEND�B`���W��-    IEND�B`��   PLTE��3�3 y��b   gzTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r�L�83R3�3J�K3��ĒT SI��3%���4��L+J�M���\�\�& ���G�m   IDAT(�c`���
FX {���$ڳ    IEND�B`��   5�����]���]�   Box3.dmi �PNG

   IHDR       `   F���   PLTE �� ��<��l   gzTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J�K3��ĒT SI��3%���4��L+J�M���\�\�& ���k<   IDAT�c`
�?�� y���;)    IEND�B`�+  ��1�l^
m\^  Shadow.dmi �PNG

   IHDR           szz�   izTXtDescription  x�%ǽ
� ����G�K(�� h�P�J�~��9�ލ����Xj~nH��H�ˡ%H,3��ZOm�EHpN,�R!1;��b��v
�����rFB   aIDATX��ױ�0DQe0��X�FK�����Sߓ�aH�κZ�             "�Ն̜�I���pN3'tS��$��o߁�2ϝ~k����� ��-    IEND�B`��  �XV�l^��]�  Chatbox.dmi �PNG

   IHDR     �   J6��   ~zTXtDescription  x��ʱ�0��`7@����t�w�r�J�^��w`'a�������;z�J.i���_2�4k��d��%*��PѠF���c�*2s����+���>��1�n����?]�2�*=?"  �IDATx���1��6 @QJ�Hm�)� I���`N�r WR���x�`�� ��:�b�OJ =��:��y� �                                                                                                                                           �r��,�?z ��Z����gӺ��&><��!������~�� a�V���y; ��V���0�0�0�����@������ ��1�_ ��e��@�5 v��~��\�p7 ��O� h� � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � ¾||�mۏeY��|���<}|v��ᰍ1��x<>jP�c�N�m��L뺎1����������u���p8�Kn����2�����`��w>������mۏ1��P4m������6�a��*� L  lc����?��x���t:�=�q.���i�^ư������. ����@�u0�ۀ��.������ ����' @��@6m�˶� �}�@��?���=�<�_~c�@� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @� @ش-/�ރ �a a1��7m��    IEND�B`�  ��-���]��]�   Tiles.dmi �PNG

   IHDR   @       ��   PLTE��� �  � ���M��\   tRNS @��f   mzTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S)�(��X��3%���7��L+J�M���p)PVp�s� E"���<   IDAT(�c��Z+GF� <9��� ]ϢƑ(`    IEND�B`�'  Mv��l^|Ȃ\�&  96x96effects.dmi �PNG

   IHDR         �� �   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)�P�U�4���H�L�(�p�KKRl���8S2��l�8ӊsS!l����Ҥ�Ԭ���Rd�&\�)�9��
�
zF�:�	l���RVp�sQp��� (�3��j    IDATx����n[�P��I}k�_�S�j��e�|�'r�\�Z��Ԧ<;_��\.'   ��To   �   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   �U� ݜ�����^�?UےH�@���G  fx��>�w��r���  L�n�w}�D�@��� `�)��@��q�(  ���^:�?P��G  � 
 �K��t�4:�U�<   �   @ ��5�r����*G�?
   Q    �   A~Uo c[{��z��j[��b�Ԓ?��s�\���A�uъ����ǲ��!�e�/��ǒ0Wq����9�c���?��O% �(���mG� �?P���%F�"�@��{#nӷ�����M��F|���M�2��:�6�}
@����#o�VF�G�6`����#o�VF�G�6�C��	�a���u�F`���۸T����6��z��t?uJ���i[���3u�V೭�ӷ��7AG�?�?���;�   ��ق��"���   �(  �$�Nq��~��V�@�����eH�p���*[ϟoβ#����|�}˩���3� ���Ku��:l#0_��v�m\����aGq>�w^��N
@����#o�VF�G�6`����#o�VF�G�6�C4�}�m����	�ވ����[F�YG�&��5 �F9-u���b�Ԓ?#P ���������U̟Z����r���v(6�ȿ��kɿ��kɿ���w��F�>:�U̟Z��\  A   �   @ ��5��:w=�U�>   �   @ ��%�r;��B�@�#�   �(  �٣�e�O'��u�(  L읆7��q�(  ��݆G��m�(  3<��W��i��\.��m   v�   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A~Uo�R���������Oն Y̟Z��e��<����l���%�ʑ�O��.�Ѓ�SK�@��͟V`J�`|�O-�U�8��9�v{���?��T9��iS   ��Z�%��S�e�Ԓ?P���E   ��   @����C)]� c2j��r��3|   ��z  �����s��{��q   >x\���X� ���f���1
�U̟Z�˻<���O�#?�˥z^�*LO�i����x<'���?��/�����xL�m��Up \Ec��7G~r�A�=�Ю����� ���i�H�}�:t�����ޒ�����i�G��@4���|��2��T�3�̄����o%���3'�N;#�0߾�h�g}ɿ��]֍��������������GOZ��z��tok^�f��19����*{/>�|�#��ǭ,u��ж ��R+��]|��57��P�������|>�~�ߚ�t[��?#r
���?�����t�׿����ےH���_K��{w��SH�O�l��   `>G X̞�Z�%�Z��߻s��}�>������p�s�>[s�ʒC�{��>:�U��̒�Pu�(�ψZ�4�������)Y�}L�<|�T������ǭ�u��� �Y{۪o��O����ۧ���ޞ4�_g���[|�7���R �x��#<���?Pe�"����~͜m��5]ɿ�9el���w�P�\?�:x��׳���1���[2��q���?#P ����^D�ȿ'�Z�߆�SK�T��\.�����'�_�u�_K���_K���_K����.�s>��# �5�/����b�Ԓ�X�v�ַ �=<[�w\��N�   �$]��  � ��5��9X���%������   ؎   AZ�%�R:~�g�Ԓ?P���E   �Ѧ �iT]�Ѓ�SK�@��Ο6�t�l���>̟Z��q��* �������b�Ԓ?P�h�]8���1|����*G�??�˥z  ���<   ,�   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   ���ހ������?_�ן�m��?��T9��iy�1�Wؚ�SK�@�#͟v�]�]����*G�?�
���;>��̟Z��q��) s���  c3j��r����"`  ���E����ZXn���SK�@�)w��Z ����?
�{{w������m�8 0�){����7|XӨ��1`,s���^����r?C��d����g� 0��/ lK� �i{��=  |Ӝ��hy�9���� |s[�`[� �*�ѭ�Ӌ�:���?���7�\.��mxi�`[|]��ʓ��9��e�`[}-�_�O-���������{���hw�mM:k^�����O�=��2e�,������������������g�( �>�r�S/�~ע�L�}���]v]^ :����e��,�2�R���z\��fM��\�"��|>�����Mz����o�YC�˽��[�g��Oz��(Z�^��c��;�^����9��ߑ� u$��=���ő��S'���C���*��3�m�t�b�� J\����f�9ugۜ�r��Б��M��<[->� �п���v�9�s��KY�ʟ���Z[,,YN��ޖ.͡mȟoR    ��$S�(8|����tO�9���M���9�S���qp����\�����"������|m'�gDm��'l�]���O�U�.Bo�?��H[|ʟѴ- ��_�%���������|v�}_�_��"��wS�~�6�{#���{t�������Π6`N��~��"��9[��[��N��9YK�˽�?���·?��(� ���������%,u�ȿ�W;�eg'�v俽w�g��y�}�mG��u�#�
@��_�wc�ԮO�o�?Pe��ٺL�?�����-�?����r�To�[s��V�?��"���ZzX��)ې-��k}��;��pK������G'���SK�|S�7�r��V���h{��V�# 7�<  �tԻP�< ��)�����F� �� �9��s����������T�z��g��a�_  F��Z�X��5  U,8k�����B����C)� �3j��2�4Į�:   t���L�# �ӼFե}=�?��T9��iS N�i�v
����%���O�p:��[�@/�O-�U�6����y���1j��r���s�\��  �I�#   �2
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    ȯ�X�|>�����z��� ��SK�@��̟�G ��1���?��T9����\.��0˧��61`|�O-�Un��qμ���Z��-�ۃ ��~��zx�wlC�@������l��9#is
МC,]� c��������=�U�.���O��Ӧ <�^�?��Uop|�f�9�}��F�0��w����s~��s̟���2���NG�����.� Ћۀ����ےH�@�gg�<��޵_ �����`�V���g=�UgȫӁ�����)@ {z6�?��q:�v�Txܡ<����t8
Ц �"��g/���ܙ��� �Q�9��������� 5��2�+����*K��̹u+�ɟo� |Z�L�%whx�Wy/��|>�~�==��,S/ �y<t������,��ٽ�n����ǲ��}�] n^�2߿鋋������^=ns��td�ۚ|̠���]���O;��|�wo�i��C���"���mQ =.�����%ϩC��^��WB�@�O���;&�}��J�?��c�;wȴe`�9{ ��-��5���0[�?s/��保w�l� |v��Ǐ?.DS3�3�v��] ��7uA�f=�������Ox��T��������	�G���m@��Y|~:'q���yw�ʳ��������,:���?�Q B�]|n��/B�Tyw$p�=��f�����   A   �   @ ��s�>�+�ԧ����$��<{������g����G��H2w��P�r{���#�ʻ��^��O����G����� ��߿{�N3�����Xl�FTK>��Ty�~9��i�Y��.8��7G$FҮ ���"���W�{���{(��w�!;:�������!���[h�:Uen�S�>u��E���b`���8h���"c�?�Ty�?��7sOOq��{���r�YcvZ��( �B�t�̛YL���EJK����`�'���?�5�ZO���8��\ʩ&�?�~.�K�6�����/�6־����z|Q~�"=�s�F���f��w���# �kq�:]~��J�@�����چ��&������:���L���^͝G��P�# s�|{{�L�^:����a�5H�ϥ6 �«�|���nU��>��Â��� ͽ�[\[Y3C̟��Ty<�8��.e� ���XK���t
b������ �1=�;�����?�t���xGid�Xߵ���ޞ��*KfI��Ӣ <s{��W�
��w���>��^�����|oj�]��ǻ������r��Ӫ �N�K@���^̟Z��m��;�]���z1j��r��Ӯ �Nσ�>Џ�SK�@�#͟v�   ˵<   ,�   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   ���ހ������?_�ן�m��?��T9�Ͽ�0sZ�����`l�f������ס]g���r�ކYn�?{x�q���[hZ�~���JG�Ѫ L	������%���v@�) s���@ �z�)��A7�'���3L�͞��  �����c�^ ��?Pi�\�^�?�J@�ۀ��� |s������,z�9��v�T9�,iQ �9�Ͽ������n�O;"��]� u ��Qw@�8h�׏�   ��c��z����q�!SOC��C��z��}�_ ����8
 ��f��?����d�t9h� P�Mj�`{m
��C�  �kq0u��Ӷ��pG%���jf�6�Ϸ] �X�XM�,�5GT����xM�c1j��f͚[}��G$?�˥z&�3���^�R���[�)�sM#��9SK�߷�3ܤ�o�S���� �,�l����y�����`x���}|�����Jo���y׍��֢ ����^��~�y���&�����#�����G�� ��g���=��v��G&�s'��h���#F� y���ڞ�E���J�3畔�#F� �m�y���?Pi�����g���   A   �  ��u:��ӶN��g괭�� ��\�Qύߚ��*���5��;��E��H2�"4m�)�R��y%e�ȟ�( a^-B�J�/q�)��h�д�#Fᝀ=���w��ګ�6��T���?����O����9is)��kq�ܳ|���;ק�|Ρ��*�����7�ݭf[w�g?�˥z^Z��W �y���=�����9���Ւ��|-�_���V; �~����X���0{�>�Ex�? #�z���k=��,�O-�����Ys������XF�V��. �[3@���T1Cjɟojs��m��a  �2|Xs��o��{(�N�m�`{��{�^~`Kv@Ԓ?Pi��� L}�Toll���sOA4֓?P��3��E��^��@ ��?p�l��߻�X��~�SOA4��#��Q�AjQ ���� �v?K���h�lG�@�#ϒ�f�9�{l���uH��=^T���%��oC�s�\��a�����֔�������͗���U8�>��n ���^ ��?P�ٜ�:{����u	��  ���#���rʖ�t:� �c�Ԓ?P�(;�   `�Vw  �Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   �����۰�_����|�}�^�����`�K���ns�(�m8���E�(0�g;�؏��
G�1?�˥zf� Tx7g̠�?�6�]�j�_�ן��������.�l�M8�Ͽ�  ��]6��C�@�#ϓ6�t�v��   x�E����=��N�m��r��Z��iރ�  �
֠m
   �a�"�Ñ��@���[K:
��U:,��� �N�/   ̕�~lQ   �m���  `l����m?�)���� �Z{�@ZG�@���/>�	���z�T��o��.�K�6���Վ�h�-6�����yT����ZN���������'%�� �y�������������ى��J3���L��?U�/ |G�9��çj;*���&�\����Gx�߶#�[7���9TK��9S ̨��R��xn�٘D�Y� �.>o���? 0 ��ϛ�.B�0�TK�   8�
�   �)��  �q1s�=���6r�
@�.�vw9W~.��̞����{ ����O��7�L �
@�Q�)�O�{���Su��:mk#���z���"���s��ؓ�`L)��
@��/����~�+�����2J�O=�(F0|X�����|����6�o|�#�?�����k���7uɟ�\.��mxK���|u��#�Z�O-���q�l���0��Ǒ0?�?@��?F'`/��L���OGͯy�,��  �˧��ȋ�#��-���qP  �Ј���ע ,	q�C/  ��k����ǵ���؆��*���_k�   ]t(m
��0�� `�5��k��C��1�=��m���aO�R-
�͔�� `�%��.�a�w~�n�o�|˔�b}���Ӝ��  IDAT�����p��|ӧSQ̠�?�v��y|!0��=<[hZ|�G����͡��S��q�QK��ގ��l[   `o�;!���_�   ]t]��kw0  ��   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    H�p>�Wo����%�u~Uo�\���^���s>��?u�����r��  `'mO  �S    H���/  �F�   l�Ep�  �F���S��*�O-��6�m@��  �3� �  ����!\  ���   ؖ�f��% `�� �����^��x,�K� �������"�Ͼ�0�=�����?� �i�ۀ��'  lo�#   ��"
����XՒ�r�%��( �ᴯZ���S  (B���]
 Cr
@-��q[ � ��[ � ��[ ��~4�c�:�c& `$��lK���'=�J� FQ �G���s)���`�̱����O� ��s�\��  �I�   ���˭% �5t�H��|>�~�8:/w�_���%��� l���v^-&?�������bs�����%��\  A ����s   ��  ���`�Xc�1֓?�w8  ��8`O  l�EXrs�  �֢ ,�͏  �o�-   ��W ��T1j�`�vw:�Ͽ��  ���ހ����{{�`O�O-�,��   ���   ^S    �   A   �   @   �(   D  � 
   Q    �   A   �z�������  �8   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   Q    �   A   �   @   �(   D  � 
   ��>]=h�    IEND�B`�  #O���3�]�3�]�  BaseNpc.dmi �PNG

   IHDR   �   �   1|�   PLTE�����f �f �  �3 ������D   tRNS @��f   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S)3%'U��3%���5��L+J�M����s��L�+**�#�&%�8������Լ��JIūNY���$ j�N�I9�   �IDATh����@C���v�����[���A��I��w[�;A�	)	!Ľx,���\w�h]��d���	 `V@���	h�	Z�
��ے�A��ݯ0����uzv����!�?����+fe�l4�(h��y���t�f���f�~�~ ��G?�Ô�pNۊ~`�0����ь��!�D�s i�<p!�ޝ�@��.��@c?�p���8�xA�����4n����/�M��k���    IEND�B`��    &���}�]�}�]�   BuildBox.dmi �PNG

   IHDR   @       �S��   PLTE��3�3 y��b   ozTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S�$�@��3%���3��L+J�M���j�3SRq)RVp�s� ��#�<l+
   IDAT�c` ��@�0���  �:�UI#�    IEND�B`��  E�ۜ��]���]�  Top_BL.dmi �PNG

   IHDR   �   `   ���   	PLTE������������;   tRNS @��f   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S�P7Y��3%���3��L+J�M���j��PcL�"Ԙ�ƌ5�D�� B�%jp+RVp�s� Lmw��  �IDATH��In� �A*�.���n@%|��4`�fLR��v�X��<����(>K�,}�(�����k#h}�(@�?�=*p�!_
�Q�k�Ӏ�ڿp@����yh-Z$��R�# �IM��nR+ %d���QiFu��V �Y+ �e2����@{M@5!!Hg���u���?�]�uGb�_B?h��� O�A���������9�i� ��� �yq/��W�0ܖPט��qS��]��@j��,甬aN6c�{�M��u�Sh�)��.��7�^ȓi�Z� �@����3C�")h��?��f�Y��%=X2���� ��RR���n^L\�
��q_�I
�ݮ��z��[����)o��:�Hh��� �H��0;���.��A��������e����� 	p�,��l�A���6�$/V ��ά���_���i/�_�o��s��҉�    IEND�B`��  ����]���]�  Base_TR.dmi �PNG

   IHDR   �   `   ���   	PLTE������������;   tRNS @��f   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S�P7I��3%���3��L+J�M���j��PcL�"Ԙ�ƌ5�D�� B�%jp+RVp�s� D]mmϤ�t  �IDATH��In� �A*�.���n@%|��4`�fLR��v�X��<����(>K�,}�(�����k#h}�(@�?�=*p�!_
�Q�k�Ӏ�ڿp@����yh-Z$��R�# �IM��nR+ %d���QiFu��V �Y+ �e2����@{M@5!!Hg���u���?�]�uGb�_B?h��� O�A���������9�i� ��� �yq/��W�0ܖPט��qS��]��@j��,甬aN6c�{�M��u�Sh�)��.��7�^ȓi�Z� �@����3C�")h��?��f�Y��%=X2���� ��RR���n^L\�
��q_�I
�ݮ��z��[����)o��:�Hh��� �H��0;���.��A��������e����� 	p�,��l�A���6�$/V ��ά���_���i/�_�o��s��҉�    IEND�B`��  ����]���]�  Base_BL.dmi �PNG

   IHDR   �   `   ���   	PLTE������������;   tRNS @��f   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S�P��3%���6��L+J�M���*��0&��
S�*��0'��
K�*p)QVp�s� �Ag׃�e�  �IDATH��In� �A*�.���n@%|��4`�fLR��v�X��<����(>K�,}�(�����k#h}�(@�?�=*p�!_
�Q�k�Ӏ�ڿp@����yh-Z$��R�# �IM��nR+ %d���QiFu��V �Y+ �e2����@{M@5!!Hg���u���?�]�uGb�_B?h��� O�A���������9�i� ��� �yq/��W�0ܖPט��qS��]��@j��,甬aN6c�{�M��u�Sh�)��.��7�^ȓi�Z� �@����3C�")h��?��f�Y��%=X2���� ��RR���n^L\�
��q_�I
�ݮ��z��[����)o��:�Hh��� �H��0;���.��A��������e����� 	p�,��l�A���6�$/V ��ά���_���i/�_�o��s��҉�    IEND�B`�   ������]ǉ�]�   BuildBox.dmi �PNG

   IHDR   @   @   ��M   PLTE��3�3 �    �"��   yzTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S�$�@��3%���3��L+J�M���j�3SR	*J�I-#J�.U�
�~.`O  g8g�Du�    IDAT8�c`��P(`@X��`T`T I  p���]�    IEND�B`� IEND�B`��  �y5 ���]ȉ�]�  Top_TR.dmi �PNG

   IHDR   �   `   ���   	PLTE������������;   tRNS @��f   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S�P7E��3%���3��L+J�M���j��PcL�"Ԙ�ƌ5�D�� B�%jp+RVp�s� S�m��3�f  �IDATH��In� �A*�.���n@%|��4`�fLR��v�X��<����(>K�,}�(�����k#h}�(@�?�=*p�!_
�Q�k�Ӏ�ڿp@����yh-Z$��R�# �IM��nR+ %d���QiFu��V �Y+ �e2����@{M@5!!Hg���u���?�]�uGb�_B?h��� O�A���������9�i� ��� �yq/��W�0ܖPט��qS��]��@j��,甬aN6c�{�M��u�Sh�)��.��7�^ȓi�Z� �@����3C�")h��?��f�Y��%=X2���� ��RR���n^L\�
��q_�I
�ݮ��z��[����)o��:�Hh��� �H��0;���.��A��������e����� 	p�,��l�A���6�$/V ��ά���_���i/�_�o��s��҉�    IEND�B`�=   �k�u�T^T^  BuildBox.dmi �PNG

   IHDR   `   @   o=   PLTE   �3 � �f ��  ��3��Fv   tRNS @��f   tzTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r���83R3�3J ��ĒT S�P��3%���6��L+J�M���*��0&��
S\*�\�\�^ f4;��D�   2IDATH���1 0ðP�R�Q*�M!֯|80��`0T�B��`hj'���Y�    IEND�B`� IEND�B`�$  �d����]���]  Box.dmi �PNG

   IHDR      �   àU   PLTE�����3�  �  �3 ������   tRNS @��f   �zTXtDescription  x�SVpru��Sp���*K-*���S�U0�3��,�L)� r�L�83R3�3J ��ĒT S))�B�P��3%���7��L+J�M��QTTU��_�J�0�2"M3&N�	Aeę�K-e�(+����#
 �v��t  IDATx����q1@Q������M�Jl��낈g�� �����~��5���O�� �x �e����`�)�  	�` a�� A�� !� �ߍ�-���8_�0�K�mp�of��`�oA&�e0�`�*��� Ep�[�d�l��?�ey��,�!�MJ`L��(���I��3 �`Շ �`٧ �`�� [���6�],�>	X�}0(}`�ma&��`\6� Up����6����t`#�W ���l	`!��� ���d`"XVn��\@l�B���� ��Kb��D�D�WD������=�:Z�~<`�����򀜀 $o� @F� rw� .� ��Mp���`d$ q�"g���3�B·��{�޳s �I��M?�U=k��UO;� �yu ��8�vb%���G�rf-`�b�xi�Ud�F=@ �' [��Np��� K�1�Jp��'�'Nf�����0�.8�	���� iH;@���v��� � iH;@���v�t�������%
�~+ �����~��H����M����ݯ �� _�8�8�ۧ�>��Y@��"}ꃀX�� ڧ �>��@�� 2}���\?���?($Z����z�`�,�J��_��� �~�گ��E {��� <�
��_ ��y����}��� ��( �'�>��9@���}
�C�x�$� �' �> ��ӀOy
9{���    IEND�B`�8   ��)�d^)�d^  Demo\DemoInterface.dmf macro "macro"
	elem 
		name = "F+REP"
	elem 
		name = "Any"
		command = "KeyDown [[*]]"
	elem 
		name = "Any+UP"
		command = "KeyUp [[*]]"


menu "menu"
	elem 
		name = "&File"
		command = ""
		saved-params = "is-checked"
	elem 
		name = "&Quit"
		command = ".quit"
		category = "&File"
		saved-params = "is-checked"


window "window1"
	elem "window1"
		type = MAIN
		pos = 372,0
		size = 1306x757
		anchor1 = none
		anchor2 = none
		background-color = none
		is-default = true
		saved-params = "pos;size;is-minimized;is-maximized"
		title = "ARPG Framework"
		statusbar = false
		macro = "macro"
		outer-size = 1324x804
		inner-size = 1306x757
	elem "browser1"
		type = BROWSER
		pos = 0,0
		size = 1306x757
		anchor1 = 0,0
		anchor2 = 100,100
		background-color = none
		is-default = true
		saved-params = ""
	elem "map1"
		type = MAP
		pos = 0,0
		size = 1306x757
		anchor1 = 0,0
		anchor2 = 100,100
		is-default = true
		saved-params = "zoom;letterbox;zoom-mode"
		on-size = "onResize \"[[id]]\" \"[[size]]\""
		icon-size = 32
		zoom = 1

window "outputwindow"
	elem "outputwindow"
		type = MAIN
		pos = 1249,663
		size = 640x309
		anchor1 = none
		anchor2 = none
		saved-params = "pos;size;is-minimized;is-maximized"
		title = "Output"
		statusbar = false
		can-close = false
		can-minimize = false
		can-resize = false
	elem "output1"
		type = OUTPUT
		pos = 0,0
		size = 640x316
		anchor1 = 0,0
		anchor2 = 100,85
		is-default = true
		saved-params = "max-lines"

