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
				
				//console.log($('#jstree'));
				
				//전부 선택해제
				//$('#jstree').jstree("deselect_all");
				
				//changed 이벤트
/* 				$("#jstree")
			    .on("changed.jstree", function (e, data) {
			      console.log(data.changed.selected); // newly selected
			      console.log(data.changed.deselected); // newly deselected
			    })
			    .jstree({
			      "plugins" : [ "changed" ]
			    }); */

				
				// 트리 생성
				//$("#jstree").jstree("open_all");
				
				$('#jstree').jstree({
					core : {
						data : academy,
						check_callback : true
					},
					types : {
						'default' : {
							'icon' : 'jstree-folder',
							//'max_depth' : 9
						}
					},
					plugins : [ 
							'changed', //select 오류 해결위해서 추가
							'contextmenu',
							'sort',//오름차순 정렬
							'types'
							]	
				
				//}).bind("changed.jstree", function (event, data) {
				//      console.log(data.changed.selected); // newly selected
				//     console.log(data.changed.deselected); // newly deselected
				// 트리 로딩 완료 이벤트	
				}).bind('loaded.jstree', function(event, data) {	
					$('#jstree').jstree('open_all');
				//}).on('changed.jstree', function(event, data) {	 
			    // 트리 선택 이벤트
				}).bind('select_node.jstree', function(event, data) {
					// 노드 선택 이벤트
					
					//console.log("changed.jstree 실행..!");							
					console.log("Selected Node:", data.node);
					//console.log("Selected data:", data);
					//console.log("이름 : ", data.node.text);
					
					// 트리 선택 이벤트에서 하위 노드 개수 확인 및 제한
			        var maxChildNodes = 9; // 최대 하위 노드 개수
			
			        if (data.node.children.length >= maxChildNodes) {
			            alert("최대 " + maxChildNodes + "개의 하위 노드만 생성할 수 있습니다.");
			            return false; // 노드 선택 취소
			        }
					
					

					// grid 틀 생성
					createGrid();
					
					// 클릭데이터 초기화
					var clickData;
					
				    // 전체 데이터를 불러오는 경우
					if (data.node.parent == "#") {
				        clickData = {};
				        getGridData(clickData);
				    }else {
				    	var originalString = data.node.text;
				    	var lastCharacter = originalString.slice(-1); // 마지막 문자 추출
				    	console.log("마지막 글자:", lastCharacter);
	    	
				    	// 선택한 노드의 끝 글자가 '호'인 경우 반으로 인식
				    	if(lastCharacter == "호"){
					        var clickData = {
					            classes: data.node.text // 선택한 노드의 이름을 classes로 전달
					        } 
					        getClassesGrid(clickData);		    		
				    	} else if(lastCharacter == "조"){	// 끝 글자가 '조'인 경우 팀으로 인식
				    		 var clickData = {
							     team: data.node.text // 선택한 노드의 이름을 team로 전달
							 } 
				    		 getTeamGrid(clickData);
				    	}	    	
				    } 
				    // 노드 선택 끝
					// changed.jstree 추가
				    
				}).bind('create_node.jstree', function(event, data) {
					// create 클릭 시 폴더 이름 설정
					// 기존에 'New Node'로 출력되었던 부분임
					//data.node.text = '폴더명을 입력하세요';
					console.log("create 버튼 클릭");
					console.log("노드 생성 데이터 : ", data);
					
					// 입력값 받기
				    var newName = prompt("새로운 노드의 이름을 입력하세요:");

				    // 입력값으로 node name 설정
				    data.node.text = newName || '';
				    
				 	// 트리 선택 이벤트에서 하위 노드 개수 확인 및 제한
			        var maxChildNodes = 10; // 최대 하위 노드 개수

			        if (data.node.parent !== "#" && data.node.parent !== null) {
			            var parentNode = $('#jstree').jstree(true).get_node(data.node.parent);
			            if (parentNode.children.length >= maxChildNodes) {
			                alert("최대 " + (maxChildNodes - 1) + "개의 하위 노드만 생성할 수 있습니다.");
			                // 노드 생성 취소
			                $('#jstree').jstree(true).delete_node(data.node.id);
			                return false;
			            }
			        }
				    
				    
					
					//treelist();
					treecreate(data); // 메소드 호출
					
				}).bind('rename_node.jstree', function(event, data) {
					console.log("rename 버튼 클릭");
					console.log("노드 변경 데이터 : ", data);
					
					//treelist();
					treerename(data); // 메소드 호출
					
				}).bind('delete_node.jstree', function(event, data) {
					console.log("delete 버튼 클릭");
					console.log("노드 삭제 데이터 : ", data);
					
					//treelist();
					treedelete(data); // 메소드 호출
					
				});
			}, // success 끝
			error : function(xhr, status, error) {
				console.error('AJAX 오류:', status, error);
			}
		}); //ajax 끝
	} //treelist 끝
	


		
 	//트리 생성
	function treecreate(data) {
 		
		
		//부모아이디 : 1
 		var parentId = data.node.parent;
 		
		// 자식아이디 : j1_1
		var id = data.node.id;
		
		//node name
        var text = data.node.text;
	
	 // countId 가져오기
	    $.ajax({
	        type: 'post',
	        url: '/countId.do',
	        contentType: 'application/json',
	        data: JSON.stringify({ parentId: parentId }), //부모아이디 값을 내보내야함!
	        dataType: 'text',
	        success: function (response) {
	        	//받아온 아이디 갯수를 int형으로 변환
	            var countId = parseInt(response);

	            // 자식아이디를 기존 아이디 번호 유무에 따라 +1 시켜주고
	            if (countId > 0) {
	                var icountId = countId + 1;
	                id = parentId + String(icountId);   
	            } else { //부모아이디 하위에 자식 아이디가 없으면 그냥 1 붙이기
	                id = parentId + '1';
	            }

	            // 출력될 아이디는 부모+바뀐아이디 로 출력해야함

	            var data = {
	                id: id,
	                parentId: parentId,
	                name: text
	            };

	            $.ajax({
	                type: 'post',
	                url: '/treecreate.do',
	                contentType: 'application/json',
	                data: JSON.stringify(data),
	                success: function (response) {
	                    // treelist();
	                    // 새로고침
	                    location.reload();
	                },
	                error: function (xhr, status, error) {
	                    console.error('AJAX 오류:', status, error);
	                }
	            });
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
		var text = data.text;
			
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
	            datatype : 'json',
	            success: function (data) {
	            	//data.node.old.text('');
	                //text = data.node.text;	        
	                //treelist();
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
	                //treelist();
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

	// 노드 선택 전체 리스트 출력
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

	// 노드 선택 조 리스트 출력
	function getTeamGrid(clickData) {
		$.ajax({
			url : '/grid/getTeamGrid', // 수정된 데이터를 처리할 서버의 엔드포인트
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
	
	// 노드 선택 반 리스트 출력
	function getClassesGrid(clickData) {
		$.ajax({
			url : '/grid/getClassesGrid', // 수정된 데이터를 처리할 서버의 엔드포인트
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

<!-- 
https://stackoverflow.com/questions/63096699/uncaught-typeerror-cannot-read-property-clientheight-of-null-chrome-2020
 -->

</html>
