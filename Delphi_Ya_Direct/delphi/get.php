<?
//OPRED
/*

*/
$iss='y';
include "../cfg/main.php";
##########################################################
if($_GET['a']=='clst')
{
	$arr = get("select * from ".DP."p_clients order by yaname");
	if($arr)foreach($arr as $k=>$v)
	echo $v['yaname']."##~~";
}
##########################################################
if($_GET['a']=='cpass' and $_GET['client'])
{
	$arr = get("select * from ".DP."p_clients where yaname='".$_GET['client']."'");
	echo base64_encode($arr[0]['yapassword']);
}
##########################################################
##########################################################
if($_GET['a']=='getfields')
{

	$file0 =  base64_decode($_POST['data']);
	#$file0 =  file_get_contents('1.tpl');
	
	//detect campain number
	$s = strpos($file0,'<H1>Кампания "');
	$tmp = substr($file0,$s+14);
	$s = strpos($tmp,'-');
	$tmp = substr($tmp,0,$s);
	
	$number = $tmp+0;
	
	
	$file = explode('<TD class=name>',$file0);
	
	unset($file[0]);
	if($file)foreach($file as $k=>$v)
	{
		#$v = iconv("UTF-8","windows-1251", $v);
		//detect key
		$s = strpos($v,'"Объявления конкурентов"');
		$v = substr($v,$s+24);
		$s = strpos($v,'">');
		$f = strpos($v,'</A></EM>');
		$key = substr($v,$s+2,$f-$s-2);
		$key = str_replace("
		","",$key);
		$res[$k]['key']=$key;
		unset($key);


		
		//detect prices names
		$s1 = strpos($v,"<NOBR>цена 1-го спецразмещения</NOBR>");
		if($s1){$p[] = substr($v,$s1+6,24);$s5=$s1;}
		
		$s2 = strpos($v,"<NOBR>вход в спецразмещение</NOBR>");
		if($s2){$p[] = substr($v,$s2+6,21);$s5=$s2;}
		
		$s3 = strpos($v,"<NOBR>цена 1-го места</NOBR>");
		if($s3){$p[] = substr($v,$s3+6,15);$s5=$s3;}
		
		$s4 = strpos($v,"<NOBR>вход в гарантированные показы</NOBR>");
		if($s4){$p[] = substr($v,$s4+6,29);$s5=$s4;}
		$res[$k]['prices']=$p;
	
		
		//detect prices values
		$v = substr($v,$s5);
		$s = strpos($v,"<TD>");
		$v = substr($v,$s+4);
		$s = strpos($v,"</TD>");
		$vv = substr($v,0,$s);
		$vv = str_replace(" ","",$vv);
		$vv = str_replace("\t","",$vv);
		$vv = str_replace("
		","",$vv);
		$res[$k]['prices2']=explode("<BR>",$vv);
		
				
		if($p)
		{
		//get input field
		$s = strpos($v,'<INPUT tabIndex=1 type=edit maxLength=6');
		$v = substr($v,$s+39);
		
		$s = strpos($v,'value=');
		$v = substr($v,$s+6);
		
				
		$s = strpos($v,' name=');
		$fval = substr($v,0,$s);
		
		$f = strpos($v,'> ');
		$fname = substr($v,$s+6,$f-$s-6);
		$res[$k]['fname']=$fname;
		$res[$k]['fval']=$fval;
		
		}
	
		unset($p,$v,$s5,$vv,$fname,$fval);
		
}
if($res)foreach($res as $k=>$v)
{
	//clear key from '-'
	$ex = explode("-",$v['key']);
	$res[$k]['keydb'] = trim($ex[0]);
	
	//get max ya stavka
	$a = get("select * from ".DP."p_projects_query where name='".$res[$k]['keydb']."' and catkey='".$number."' and del='n'");
	$res[$k]['maxpaydirect'] = $a[0]['maxpaydirect']+0;
	$res[$k]['id'] = $a[0]['id'];
	$res[$k]['st2'] = $a[0]['st2'];
	
	//get ya pos
	$a = get("select * from ".DP."p_query_pos where pid='".$res[$k]['id']."' order by date desc limit 1");
	if($a[0]['pos']<1) $a[0]['pos']=999;
	$res[$k]['yapos'] = $a[0]['pos'];

	
if($res[$k]['st2']=="y")
{
	if($res[$k]['yapos']<11)
	{
		if($res[$k]['yapos']<4)	{$stat = "вход в гарантированные показы";}
		else {$stat = "цена 1-го места";}
	}
	else{$stat = "вход в спецразмещение";}
}
else{$stat = "none";}

$res[$k]['stat'] = $stat;

//detect ya price for cur stat
if($res[$k]['prices'])foreach($res[$k]['prices'] as $kp=>$vp)
{
	if($vp==$res[$k]['stat']) $res[$k]['statprice'] = $res[$k]['prices2'][$kp];
}
	
}
#get_arr($res);

//ECHO
if($res)foreach($res as $k=>$v)
{
	if($v['maxpaydirect']<=$v['fval']) $fval = $v['maxpaydirect'];
	else $fval = $v['fval'];
	
	//calc summ
	if($v['maxpaydirect'] >= $v['statprice'])
	{
		$razn = $v['maxpaydirect'] - $v['statprice'];
		if($razn<0.07)
			$res[$k]['maxpaycalculate'] = $v['maxpaydirect'];
		else
			$res[$k]['maxpaycalculate'] = $v['statprice'] + 0.07;
	}
	else $res[$k]['maxpaycalculate'] = $fval;
	
	if($res[$k]['maxpaydirect']<=0)  $res[$k]['maxpaycalculate'] = $v['statprice'] + 0.05;
	
	
	if($v['fname'])
		echo $v['fname']."##".($v['fval'])."##".($v['yapos']+0)."##".$v['stat']."##".($v['statprice']+0)."##".$res[$k]['maxpaydirect']."##".$res[$k]['maxpaycalculate']."##~~";
}

}
##########################################################
##########################################################
##########################################################
if($_GET['a']=='getfieldsbegun')
{

	$file0 =  base64_decode($_POST['data']);
	#$file0 =  file_get_contents('logfile.tpl');
	
	//detect campain number
	$s = strpos($file0,'<TD class=smallblgr>');
	$tmp = substr($file0,$s+20);
	$s = strpos($tmp,'-');
	$tmp = substr($tmp,0,$s);
	
	$number = $tmp+0;
	
	//tbl begin
	$s = strpos($file0,'&nbsp;Ставка,&nbsp; руб.</TD></TR>');
	$file0 = substr($file0,$s+34);
	$s = strpos($file0,'</TBODY></TABLE></TD></TR></TBODY></TABLE>');
	$file0 = substr($file0,0,$s);
	
	$file0 = str_replace("<TBODY>
<TR>","",$file0);

	$file0 = str_replace("</TR></TBODY>","",$file0);
	
	$file = explode('<TR>',$file0);
	unset($file[0]);
	
	if($file)foreach($file as $k=>$v)
	{
		
		$ss[1]='<TD style="PADDING-RIGHT: 7px; PADDING-LEFT: 7px; PADDING-BOTTOM: 3px; PADDING-TOP: 3px" bgColor=#ffffff>';
		$ss[0]='<TD style="PADDING-RIGHT: 7px; PADDING-LEFT: 7px; PADDING-BOTTOM: 3px; PADDING-TOP: 3px" bgColor=#fafafa>';
				
		$s = strpos($v,$ss[($k%2)]);
		$v = substr($v,$s+105);
		$s = strpos($v,'</TD>');
		$v = substr($v,0,$s);
		$rr['name']=trim($v);
		
		$v = $file[$k];
		for($i=1;$i<=12;$i++)
		{
			$s = strpos($v,"<TD ");
			$v = substr($v,$s+4);
		}
		$s = strpos($v,">");
		$f = strpos($v,"<BR>");
		$v = substr($v,$s+1,$f-$s-1);
		$rr['price']=trim($v);
		
		$v = $file[$k];
		$s = strpos($v,"<INPUT size=5 value=");
		$v = substr($v,$s+20);
		$s = strpos($v," name=");
		$vv = substr($v,0,$s);
		
		$f = strpos($v,"> </TD>");
		$v = substr($v,$s+6,$f-$s-6);
		$rr['fvalue']=trim($vv);
		$rr['fname']=trim($v);
		
		$res[]=$rr;
	}
	
	foreach($res as $k=>$v)
	{
	
		//get max ya stavka
		$a = get("select * from ".DP."p_projects_query where name='".$res[$k]['name']."' and catkey='".$number."'  and del='n'");
		$res[$k]['maxpaydirect'] = round(($a[0]['maxpaydirect']+0)*30);
		$res[$k]['id'] = $a[0]['id'];
		$res[$k]['st2'] = $a[0]['st2'];
		$res[$k]['yapos'] =  $a[0]['posrambler'];
		
		if($res[$k]['yapos'] == 0) $res[$k]['yapos']=20;

		if($res[$k]['st2']=="y")
		{
			if($res[$k]['yapos']<11) $stat = 6; else $stat = 2;
		}
		else{$stat = 6;}
	
		if($stat==6) $res[$k]['maxpaycalculate']=3;
		
		if($stat==2)
		{
			if($res[$k]['maxpaydirect']-$res[$k]['price']>0) $res[$k]['maxpaycalculate'] = $res[$k]['price']-1;
			if($res[$k]['maxpaydirect']-$res[$k]['price']<=0) $res[$k]['maxpaycalculate'] = $res[$k]['maxpaydirect'];
		}
		
		if($res[$k]['maxpaycalculate']==0) $res[$k]['maxpaycalculate']=3;

	echo $v['fname']."##".$res[$k]['maxpaycalculate']."##".$res[$k]['maxpaydirect']."##".$v['name']."##".$res[$k]['yapos']."##".$res[$k]['id']."##~~";
	
	}
	
	#get_arr($res);
}
##########################################################
?>