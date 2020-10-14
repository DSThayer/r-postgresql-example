library(tcltk);

getLogin<-function(userName=''){  
	require(tcltk);  
	wnd<-tktoplevel();
	tclVar(userName)->user;
	tclVar("")->passVar;
	#Label  

	#Username box  
	tkgrid(tklabel(wnd,text="Username:"));  
	tkgrid(tkentry(wnd,textvariable=user)->passBox);  

	#Password box  
	tkgrid(tklabel(wnd,text="Password:"));  
	tkgrid(tkentry(wnd,textvariable=passVar,show="*")->passBox);  
	#Hitting return will also submit password  
	tkbind(passBox,"<Return>",function() tkdestroy(wnd));  
	#OK button  
	tkgrid(tkbutton(wnd,text="OK",command=function() tkdestroy(wnd)));  
	#Wait for user to click OK  
	tkwait.window(wnd);  
	password<-tclvalue(passVar);
	userName<-tclvalue(user);
	return(c(userName,password));  
} 