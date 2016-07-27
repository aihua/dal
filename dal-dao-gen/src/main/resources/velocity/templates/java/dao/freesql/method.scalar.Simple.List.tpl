#foreach($method in $host.getMethods())
#if($method.getCrud_type()=="select")
##简单类型并且返回值是List
#if($method.isSampleType() && $method.isReturnList())

	/**
	 * ${method.getComments()}
	**/
	public List<${method.getPojoClassName()}> ${method.getName()}(${method.getParameterDeclaration()}) throws SQLException {	
		hints = DalHints.createIfAbsent(hints);
#parse("templates/java/Hints.java.tpl")

		FreeSelectSqlBuilder<List<${method.getPojoClassName()}>> builder = new FreeSelectSqlBuilder<>(dbCategory);
		builder.setTemplate("${method.getSql()}");
		StatementParameters parameters = new StatementParameters();
#if($method.hasParameters())
		int i = 1;
#end		
#if($method.hasParameters())
#foreach($p in $method.getParameters())
#set($sensitiveflag = "")	
#if(${p.isSensitive()})
#set($sensitiveflag = "Sensitive")
#end	
#if($p.isInParameter())
		i = parameters.set$!{sensitiveflag}InParameter(i, "${p.getAlias()}", ${p.getJavaTypeDisplay()}, ${p.getAlias()});
#else
		parameters.set$!{sensitiveflag}(i++, "${p.getAlias()}", ${p.getJavaTypeDisplay()}, ${p.getName()});
#end
#end
#end
#if($method.isPaging())
		builder.simpleType().atPage(pageNo, pageSize);
#else
		builder.simpleType();
#end

		return queryDao.query(builder, parameters, hints);
	}
#end
#end
#end