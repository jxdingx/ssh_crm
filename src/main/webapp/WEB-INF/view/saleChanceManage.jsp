<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/crm.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js"></script>
<title>Insert title here</title>
<script type="text/javascript">
	$(function() {
		$('#dg').datagrid({
			toolbar : "#tb",
			method : "post",
			rownumbers : true,
			singleSelect : true,
			fit : true,
			striped : true,
			fitColumns : true,
			checkOnSelect : false,
			pagination : true,
			pageNumber : 1,
			pageSize : 15,
			pageList : [ 15, 20, 30 ],
		});
		var p = $('#dg').datagrid('getPager');
		$(p).pagination({
			onSelectPage : function(pageNumber, pageSize) {
				findallSaleChance(pageNumber, pageSize);
			}
		});
		$('#win').window({
			title : '营销机会信息',
			width : 700,
			height : 550,
			closed : true,//初始时是关闭状态
			cache : false,
			modal : true,//模态
			doSize : true,
			border : 'thin',
			yIndex : 300,
			onClose : function() {
				$('#Form').form("clear");
			}
		});
		$('#state').combobox({
			editable : false,
			valueField : 'state',
			textField : 'text',
			data : [ {
				"state" : '',
				"text" : "请选择..",
				"selected" : true
			}, {
				"state" : '1',
				"text" : "已分配"
			}, {
				"state" : '0',
				"text" : "未分配"
			} ]
		});
		$(".easyui-numberspinner").numberspinner({
			min : 0,
			max : 100,
		});
		findallSaleChance(1, 15);
	});
	function findallSaleChance(pageNumber, pageSize) {
		var customerName = $("#customerName").textbox("getValue");
		var overView = $("#overView").textbox("getValue");
		var createMan = $("#createMan").textbox("getValue");
		var state = $("#state").combobox("getValue");
		$('#dg').datagrid({
			url : "saleChance_findall.action",
			queryParams : {
				customerName : customerName,
				overView : overView,
				createMan : createMan,
				state : state,
				page : pageNumber,
				rows : pageSize
			}
		});
	}
	function addSaleChance() {
		$('#win').window("open");
	}

	function updateit(index) {
		var row = $('#dg').datagrid('getData').rows[index];
		$('#Form').form('load', row);
		$('#win').window("open");
	}
	function WinClose() {
		$('#win').window("close");
	}
	function FormSubmit() {
		$('#Form').form({
			url : "saleChance_update.action",
			onSubmit : function() {
				var isValid = $(this).form('validate');
				if (!isValid) {
					$.messager.alert("操作提示", '请填写完整表单!', "info"); // 如果表单是无效的则隐藏进度条
				}
				return isValid; // 返回false终止表单提交
			},
			success : function(data) {
				data = JSON.parse(data);
				var result = data.result;
				if (result == "insert") {
					result = "添加成功!";
				} else if (result == "update") {
					result = "修改成功!";
				}
				$.messager.alert("操作提示", result, "info");
				$('#dg').datagrid("reload");
				WinClose();
			}
		});
		// submit the form    
		$('#Form').submit();
	}

	var ff = function(value) {
		if (value == 1) {
			return "已分配";
		}
		if (value == 0) {
			return "未分配";
		}
	}

	var actionff = function(value, row, index) {
		return "<a onclick='updateit(" + index
				+ ")'><span style='color:blue'>修改</span></a>";
	}
</script>
</head>
<body>
	<table id="dg">
		<thead>
			<tr>
				<th data-options="field:'id'" hidden="true"></th>
				<th data-options="field:'chanceSource'" hidden="true">机会来源</th>
				<th data-options="field:'customerName',width:60,align:'center'">客户名称</th>
				<th data-options="field:'cgjl'" hidden="true">成功几率</th>
				<th data-options="field:'overView',width:150,align:'center'">概要</th>
				<th data-options="field:'linkMan',width:60,align:'center'">联系人</th>
				<th data-options="field:'linkPhone',width:80,align:'center'">联系电话</th>
				<th data-options="field:'description'" hidden="true">机会描述</th>
				<th data-options="field:'createMan',width:60,align:'center'">创建人</th>
				<th data-options="field:'createTime',width:150,align:'center'">创建时间</th>
				<th data-options="field:'assignMan'" hidden="true">指派人</th>
				<th data-options="field:'assignTime'" hidden="true">指派时间</th>
				<th data-options="field:'devResult'" hidden="true">客户开发状态</th>
				<th data-options="field:'state',width:150,align:'center',formatter:ff">分配状态</th>
				<th data-options="field:'s',width:80,align:'center',formatter:actionff">操作</th>
			</tr>
		</thead>
	</table>
	<div id="tb" style="height: 55px;">
		<br>
		<label style="margin-left: 30px;">客户名称:</label>
		&nbsp;&nbsp;
		<input id="customerName" class="easyui-textbox" data-options="iconCls:'icon-search'" style="width: 120px">
		<label style="margin-left: 30px;">概要:</label>
		&nbsp;&nbsp;
		<input id="overView" class="easyui-textbox" data-options="iconCls:'icon-search'" style="width: 120px">
		<label style="margin-left: 30px;">创建人:</label>
		&nbsp;&nbsp;
		<input id="createMan" class="easyui-textbox" data-options="iconCls:'icon-search'" style="width: 120px">

		<label style="margin-left: 30px;">分配状态:</label>
		&nbsp;&nbsp;
		<input id="state" style="width: 80px">

		<a href="#" class="easyui-linkbutton" onclick="findallSaleChance(1,15)" style="background: #E0ECFF; width: 100px; height: 31px; margin-left: 40px;" data-options="plain:true,iconCls:'icon-search'">
			<span class="crmbuttonfont">查询</span>
		</a>
		<a href="#" class="easyui-linkbutton" onclick="addSaleChance()" style="background: #E0ECFF; width: 100px; height: 31px; margin-right: 40px; float: right;"
			data-options="plain:true,iconCls:'icon-search'">
			<span class="crmbuttonfont">添加</span>
		</a>
	</div>
	<div id="win">
		<div style="margin-left: 40px;">
			<form method="post" id="Form" enctype="multipart/form-data">
				<div hidden="true">
					<input name="id" class="easyui-textbox">
					<input name="state" class="easyui-textbox">
					<input name="devResult" class="easyui-textbox">
				</div>
				<br>
				<table style="margin: 0px 0px 0px 40px; border-collapse: separate; border-spacing: 10px;" cellpadding="10">
					<tr>
						<td>
							<label>客户名称:</label>
						</td>
						<td>
							<input name="customerName" class="easyui-textbox" data-options="required:true" style="width: 130px; height: 30px;">
						</td>
						<td>
							<label>联系人:</label>
						</td>
						<td>
							<input name="linkMan" class="easyui-textbox" style="width: 130px; height: 30px;">
						</td>
					</tr>
					<tr>
						<td>
							<label>机会来源:</label>
						</td>
						<td>
							<input name="chanceSource" class="easyui-textbox" style="width: 130px; height: 30px;">
						</td>
						<td>
							<label>联系电话 :</label>
						</td>
						<td>
							<input name="linkPhone" class="easyui-textbox" style="width: 130px; height: 30px;">
						</td>
					</tr>
					<tr>
						<td>
							<label>成功几率:</label>
						</td>
						<td>
							<input name="cgjl" class="easyui-numberspinner" data-options="required:true" style="width: 130px; height: 30px;">
						</td>
						<td></td>
					</tr>
				</table>
				<label style="margin-left: 60px;">概要:</label>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="overView" class="easyui-textbox" style="width: 380px; height: 30px;">
				<br>
				<br>
				<label style="margin-left: 60px;">机会描述:</label>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="description" class="easyui-textbox" data-options="multiline:true" style="width: 380px; height: 60px;">
				<br>

				<table style="margin: 0px 0px 0px 40px; border-collapse: separate; border-spacing: 10px;" cellpadding="14">
					<tr>
						<td>
							<label>创建人:</label>
						</td>
						<td>
							<input name="createMan" class="easyui-textbox" data-options="required:true" style="width: 130px; height: 30px;">
						</td>
						<td>
							<label>创建时间:</label>
						</td>
						<td>
							<input name="createTime" class="easyui-datebox" data-options="required:true,editable:false" style="width: 130px; height: 30px;">
						</td>
					</tr>
					<tr>
						<td>
							<label>指派给:</label>
						</td>
						<td>
							<input name="assignMan" class="easyui-combobox" data-options="required:true,panelHeight:'auto',editable:false,valueField:'trueName',textField:'trueName',url:'user_getManager.action'"
								style="width: 130px; height: 30px;">
						</td>
						<td>
							<label>指派时间 :</label>
						</td>
						<td>
							<input name="assignTime" class="easyui-datebox" data-options="editable:false" style="width: 130px; height: 30px;">
						</td>
					</tr>
				</table>
				<br>
				<a class="easyui-linkbutton" onclick="FormSubmit()" style="width: 100px; height: 34px; margin-left: 30%">保存</a>
				<a href="#" class="easyui-linkbutton" onclick="WinClose()" style="width: 100px; height: 34px; margin-left: 40px;">取消</a>
			</form>
		</div>
	</div>
</body>
</html>