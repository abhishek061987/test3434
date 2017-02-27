import {Component,OnInit} from '@angular/core';
import {Router} from '@angular/router';
import {AuthService} from '../services/authservice';
import {User} from '../login/user';
import { Validators,FormControl,FormGroup,FormBuilder} from '@angular/forms'; 
import {Message} from 'primeng/primeng';

@Component({
    moduleId:module.id,
    selector:'login',
    templateUrl:'login.html',
    providers:[AuthService]
})
export class LoginComponent  implements OnInit{
    model: any = {};
    msgs: Message[] = [];    
    userform: FormGroup;    
    submitted: boolean;  
        
     constructor(private authenticationService: AuthService, private router: Router,private _fb: FormBuilder) {
            console.log('constructor login');
//     //called first time before the ngOnInit()
    }
    ngOnInit(){
     //called after the constructor and called  after the first ngOnChanges() 
    // reset login status
        this.authenticationService.logout();
            console.log('login coponent ngonit logout login');

        this.userform = this._fb.group({
            'cusername': new FormControl('', Validators.required),
            'cpassword': new FormControl('', Validators.compose([Validators.required, Validators.minLength(4)]))
        });
 }
  login() {
    console.log('model    ', this.model.username);
        console.log('model   password  ', this.model.password);
        this.authenticationService.authenticateNow(this.model.username, this.model.password)
            .subscribe(result => {
                if (result === true) {
                    // login successful
                     console.log('login successful    ', this.model.username);
                    this.router.navigate(['/dashboard']);
                } else {
                    // login failed
                    this.msgs.push({severity:'warn', summary:'Failed', detail:'Username or password is incorrect'});
                }
            });
  }
}



<form [formGroup]="userform" (ngSubmit)="login()">
  <p-growl [value]="msgs" ></p-growl>
    
    <p-panel header="Login">
        <div class="ui-grid ui-grid-responsive ui-grid-pad ui-fluid" style="margin: 10px 0px">
            <div class="ui-grid-row">
                <div class="ui-grid-col-2">
                    User Name *:
                </div>
                <div class="ui-grid-col-6">
                    <input pInputText type="text" formControlName="cusername" placeholder="Required"  [(ngModel)]="model.username"/>
                </div>
                <div class="ui-grid-col-4">
                    <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!userform.controls['cusername'].valid&&userform.controls['cusername'].dirty">
                        <i class="fa fa-close"></i>
                         User Name is required
                    </div>
                </div>
            </div>
            
            <div class="ui-grid-row">
                <div class="ui-grid-col-2">
                    Password *:
                </div>
                <div class="ui-grid-col-6">
                    <input pInputText type="password" formControlName="cpassword" placeholder="Required - Min(4)"   [(ngModel)]="model.password" />
                </div>
                <div class="ui-grid-col-4">
                    <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!userform.controls['cpassword'].valid&&userform.controls['cpassword'].dirty">
                        <i class="fa fa-close"></i>
                        <span *ngIf="userform.controls['cpassword'].errors['required']">Password is required</span>
                        <span *ngIf="userform.controls['cpassword'].errors['minlength']">Must be longer than 4 characters</span>
                    </div>
                </div>
            </div>
           
            
            <div class="ui-grid-row">
                <div class="ui-grid-col-2"></div>
                <div class="ui-grid-col-6">
                    <button pButton type="submit" class="ui-button-warning" label="Submit" [disabled]="!userform.valid"></button>
                </div>
                <div class="ui-grid-col-4"></div>
            </div>
         
        </div>   
    </p-panel> 
</form>
export class User{
    username:string;
    password:string;
}
