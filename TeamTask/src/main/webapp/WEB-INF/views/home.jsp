<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>jsTree and Toast UI Grid Integration</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
<link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>
</head>
<body>
<!-- jstree가 생성될 곳 -->
<div id="jstree"></div>
<br />
<!-- grid가 생성될 곳 -->
<div id="grid-container"></div>
<script>
$(function() {
	var grid = null;
	
	// jstree 불러오기
	treelist();

	
	//트리 리스트 출력
	function treelist() {
		//트리 데이터 가져오기
		$.ajax({
			type : 'post',
			url : '/treelist.do',
			dataType : 'json',
			success : function(data) {
				console.log(data);
				var academy = new Array();
				// 데이터 받아옴
				$.each(data, function(idx, item) {
					academy[idx] = {
						id : item.id,
						parent : item.parentId,
						text : item.name
					};
				});
				// 트리 생성
				$('#jstree').jstree({
					core : {
						data : academy,
						check_callback : true
					},
					types : {
						'default' : {
							'icon' : 'jstree-folder'
						}
					},
					plugins : [ 'contextmenu' ]
				
				
					// 트리 로딩 완료 이벤트
					
				}).bind('select_node.jstree', function(event, data) {
					// 노드 선택 이벤트
					console.log("Selected Node:", data.node);
					console.log("Selected data:", data);
					console.log("이름 : ", data.node.text);

					// Toast UI Grid 생성 및 표시
					// grid 틀 생성
					createGrid();
					
					var clickData = {
						id: 1
					}
					
					getGridData(1);
				}).bind('rename_node.jstree', function(event, data) {
					console.log("노드 변경 데이터 : ", data);
					treerename(data); // 메소드 호출
				}).bind('create_node.jstree', function(event, data) {
					// create 클릭 시 폴더 이름 설정
					// 기존에 'New Node'로 출력되었던 부분임
					//data.node.text = '폴더명을 입력하세요';
					console.log("노드 생성 데이터 : ", data);
					treecreate(data); // 메소드 호출
				}).bind('delete_node.jstree', function(event, data) {
					console.log("노드 삭제 데이터 : ", data);
					 treedelete(data); // 메소드 호출
				}).bind("refresh.jstree", function(event, data) {	 
				}).bind('loaded.jstree', function(event, data) {
				});
			}, // success 끝
			error : function(xhr, status, error) {
				console.error('AJAX 오류:', status, error);
			}
		}); //ajax 끝
	} //treelist 끝
	
	
	//아이디 개수.....
/* 	function countId() {
           
	        $.ajax({
	            type: 'post',
	            url: '/countId.do',
	            data: JSON.stringify(data),
	            datatype : 'json',
	            success: function (response) {	               
	                console.log(response)
	            },
	            error: function (xhr, status, error) {
	                console.error('AJAX 오류:', status, error);
	            }
	        });
	}   */
	
	
		
 	//트리 생성
	function treecreate(data) {
 		
		//countId();		
 		
		var id = data.node.parent + data.node.id;
		var parentId = data.node.parent;
		var text = data.node.text; //New Node
		
		console.log(id);
		console.log(parentId);
		console.log(text);
		
		var data = 
			{
				//아이디
				id : id,
				//부모 아이디
				parentId : parentId,
				//트리 이름
				name : text
			};
            
	        $.ajax({
	            type: 'post',
	            url: '/treecreate.do',
	            contentType: 'application/json',
	            data: JSON.stringify(data),
	            //datatype : 'json',
	            success: function (response) {	               
	                //treelist();
	            },
	            error: function (xhr, status, error) {
	                console.error('AJAX 오류:', status, error);
	            }
	        });
	}  

	
 	//트리 수정(완료)
	function treerename(data) {
		var id = data.node.id;
		var parentId = data.node.parent;
		var text = data.node.text;
		
		console.log(id);
		console.log(parentId);
		console.log(text); // 바뀐이름 나옴
		
			
		var ids = {
			//아이디
			id : id,
			//부모 아이디
			parentId : parentId,
			//트리 이름
			name : text
		};
		

		
	        $.ajax({
	            type: 'POST',
	            url: '/treerename.do',
	            data: JSON.stringify(ids),
	            contentType: 'application/json',
	            dataType : 'json',
	            success: function (data) {
	            	console.log(ids);
	            	//data.node.text = text;
	            	//data.node.original.text(text);
	                //text = data.node.text;	        
	               // treelist();
	            },
	            error: function (xhr, status, error) {
	                console.error('AJAX 오류:', status, error);
	            }
	        });
		
	} 
	
	
	
 //트리 삭제
	function treedelete(data) {
		var id = data.node.id;
		var parentId = data.node.parent;
			
		var data = {
			//아이디
			id : id,
			//부모 아이디
			parentId : parentId
		};
		
	        $.ajax({
	            type: 'post',
	            url: '/treedelete.do',
	            data: JSON.stringify(data),
	            contentType: 'application/json',
	            datatype : 'json',
	            success: function (data) {
	                treelist();
	            },
	            error: function (xhr, status, error) {
	                console.error('AJAX 오류:', status, error);
	            }
	        });
		
		
	}
	 
	
	
	
	
	// Grid 틀 생성
	function createGrid() {
		if(grid != null) {
			grid.destroy();
		}
		
		grid = new tui.Grid({
			el : document.getElementById('grid-container'),
			scrollX : false,
			scrollY : false,
			// name이 자바 변수이름과 같아야함
			columns : [ {
				header : '번호',
				name : 'stId'
			}, {
				header : '이름',
				name : 'stName'
			}, {
				header : '연락처',
				name : 'tel',
				editor : 'text'
			}, {
				header : '전공자 유무',
				name : 'majorType',
				formatter : 'listItemText',
				editor : {
					type : 'select',
					options : {
						listItems : [ {
							text : '전공자',
							value : '1'
						}, {
							text : '비전공자',
							value : '2'
						} ]
					}
				}
			}, {
				header : '자격증',
				name : 'certificate',
				formatter : 'listItemText',
				editor : {
					type : 'checkbox',
					options : {
						listItems : [ {
							text : '정보처리기사',
							value : '1'
						}, {
							text : 'SQLD',
							value : '2'
						}, {
							text : '빅데이터분석기사',
							value : '3'
						}, {
							text : '정보처리기능사',
							value : '4'
						}, {
							text : '정보처리산업기사',
							value : '5'
						}, {
							text : '-',
							value : '6'
						} ]
					}
				}
			}, {
				header : '평가',
				name : 'grade',
				formatter : 'listItemText',
				editor : {
					type : 'radio',
					options : {
						listItems : [ {
							text : '★☆☆☆☆',
							value : '1'
						}, {
							text : '★★☆☆☆',
							value : '2'
						}, {
							text : '★★★☆☆',
							value : '3'
						}, {
							text : '★★★★☆',
							value : '4'
						}, {
							text : '★★★★★',
							value : '5'
						} ]
					}
				}
			} ]
		});
		
		tui.Grid.applyTheme('striped', { // 테마 설정
		    cell: {
		        head: {
		            background: '#eef'
		        },
		        evenRow: {
		            background: '#fee'
		        }
		    }
		});
		
		// afterChange 이벤트 핸들러
		grid.on('afterChange', function(ev) {
			console.log('after change:', ev);

			var changes = ev.changes;
			var rowKey = changes[0].rowKey + 1;
			var columnName = changes[0].columnName;
			var value = changes[0].value;

			var student = {
				stId : rowKey,
				columnName : columnName,
				value : value,
			};

			console.log('student:', student);

			// 서버로 데이터 전송
			$.ajax({
				url : '/grid/gridUpdate', // 수정된 데이터를 처리할 서버의 엔드포인트
				type : 'POST',
				contentType : 'application/json',
				data : JSON.stringify(student),
				success : function(response) {
					// 서버의 응답을 처리 (필요하다면 추가적인 로직을 구현하세요)
					console.log(response);
				},
				error : function(xhr, status, error) {
					console.error('AJAX 오류:', status, error);
				}
			});
		});
	}

	function getGridData(clickData) {
		$.ajax({
			url : '/grid/getGridData', // 수정된 데이터를 처리할 서버의 엔드포인트
			type : 'POST',
			contentType : 'application/json',
			data : JSON.stringify(clickData),
			dataType : 'json',
			success : function(response) {
				console.log(response);
				grid.resetData(response);
			},
			error : function(xhr, status, error) {
				console.error('AJAX 오류:', status, error);
			}
		});
	}
	
	
});




</script>
</body>
</html>
