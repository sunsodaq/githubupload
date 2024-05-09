console.log("사랑")
let replyService =(function(){
	const add =(reply, callback)=>{
		console.log("reply...........")
		return callback(7+reply)
	}
	const sub=(vv, uu, g, f)=>{//f,g는 함수 
		//채우세요
		return {"g":g(uu,vv) ,"f":f(vv,uu+10)}
	}
	const mul =(pp, rr, g,k)=>{
		var sum1=0
		for(var i of rr) sum1+=i
		for(var i of rr) sum1+=g(pp,i)
		var arrpp= rr.map(i=>i*pp)
		var filteredArr= rr.filter(k)
		return {sum1, rr,filteredArr ,arrpp}
	}
	
	return {add,sub,mul}
})() //IFFE ,선언과 동시에 호출 
let u = replyService.add(7,(v)=>v*10)
console.log(u)
let v = replyService.sub (7,11,(u,r)=>u*r , (www,rrr)=>www*rrr*10)

console.log('g:',v.g,'f:',v.f)
let arrRes = replyService.mul(3,[2,3,4,5,11],(u,v)=> u*v*4, i=>i%2==0)
console.log(arrRes.sum1)
console.log(arrRes.rr)
console.log(arrRes.filteredArr)
console.log(arrRes.arrpp)