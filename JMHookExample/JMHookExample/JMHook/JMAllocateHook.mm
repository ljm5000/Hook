//
//  JMAllocateHook.m
//  Unity-iPhone
//
//  Created by jimmy on 2019/12/17.
//

#import <Foundation/Foundation.h>
#include "fishhook.h"
#import <mach/vm_map.h>


extern int rebind_symbols(struct rebinding rebindings[], size_t rebindings_nel);




mach_msg_return_t (*org_mach_msg)(
        mach_msg_header_t *msg,
        mach_msg_option_t option,
        mach_msg_size_t send_size,
        mach_msg_size_t rcv_size,
        mach_port_name_t rcv_name,
        mach_msg_timeout_t timeout,
        mach_port_name_t notify
                           );

mach_msg_return_t new_mach_msg(
mach_msg_header_t *msg,
mach_msg_option_t option,
mach_msg_size_t send_size,
mach_msg_size_t rcv_size,
mach_port_name_t rcv_name,
mach_msg_timeout_t timeout,
mach_port_name_t notify
                                  ){
    
   // printf("msg_return_t ");
    
    return org_mach_msg(
    msg,
     option,
     send_size,
     rcv_size,
     rcv_name,
     timeout,
     notify
                        );
}


kern_return_t (* org_vm_map)
(
    vm_map_t target_task,
    vm_address_t *address,
    vm_size_t size,
    vm_address_t mask,
    int flags,
    mem_entry_name_port_t object,
    vm_offset_t offset,
    boolean_t copy,
    vm_prot_t cur_protection,
    vm_prot_t max_protection,
    vm_inherit_t inheritance
);

kern_return_t  new_vm_map
(
    vm_map_t target_task,
    vm_address_t *address,
    vm_size_t size,
    vm_address_t mask,
    int flags,
    mem_entry_name_port_t object,
    vm_offset_t offset,
    boolean_t copy,
    vm_prot_t cur_protection,
    vm_prot_t max_protection,
    vm_inherit_t inheritance
 ){
    printf("new_vm_map size %lx %p\n",size,address);
    return org_vm_map( target_task,
     address,
     size,
     mask,
     flags,
     object,
     offset,
     copy,
     cur_protection,
     max_protection,
     inheritance);
}

kern_return_t (*org_vm_inherit)
(
    vm_map_t target_task,
    vm_address_t address,
    vm_size_t size,
    vm_inherit_t new_inheritance
);

kern_return_t new_vm_inherit
(
    vm_map_t target_task,
    vm_address_t address,
    vm_size_t size,
    vm_inherit_t new_inheritance
 ){
    printf("new_vm_inherit %lx\n",size);
    
    return org_vm_inherit(
        target_task,
        address,
        size,
        new_inheritance
                          );
}

kern_return_t (* org_vm_allocate)
(
    vm_map_t target_task,
    vm_address_t *address,
    vm_size_t size,
    int flags
);

kern_return_t new_vm_allocate
(
    vm_map_t target_task,
    vm_address_t *address,
    vm_size_t size,
    int flags
 ){
    printf("new_vm_allocate size %lx\n",size);
    return org_vm_allocate(target_task,address,size,flags);
}

kern_return_t ( *org_mach_make_memory_entry)
(
    vm_map_t target_task,
    vm_size_t *size,
    vm_offset_t offset,
    vm_prot_t permission,
    mem_entry_name_port_t *object_handle,
    mem_entry_name_port_t parent_entry
);

kern_return_t (* org_vm_map_enter)(

        vm_map_t map,
        vm_map_offset_t*address,
        vm_map_size_t size,
        vm_map_offset_t mask,
        int flags,
        void * object,
        vm_object_offset_t offset,
        boolean_t needs_copy,
        vm_prot_t cur_protection,
        vm_prot_t max_protection,
        vm_inherit_t inheritance
);

kern_return_t new_vm_map_enter(

        vm_map_t map,
        vm_map_offset_t*address,
        vm_map_size_t size,
        vm_map_offset_t mask,
        int flags,
        void * object,
        vm_object_offset_t offset,
        boolean_t needs_copy,
        vm_prot_t cur_protection,
        vm_prot_t max_protection,
        vm_inherit_t inheritance
                               ){
    
  printf("new_vm_map_enter \n");
    
    return org_vm_map_enter(

     map,
    address,
     size,
     mask,
     flags,
    object,
     offset,
     needs_copy,
     cur_protection,
     max_protection,
     inheritance
                            );
}


kern_return_t new_mach_make_memory_entry
(
    vm_map_t target_task,
    vm_size_t *size,
    vm_offset_t offset,
    vm_prot_t permission,
    mem_entry_name_port_t *object_handle,
    mem_entry_name_port_t parent_entry
 ){
    
       printf("new_mach_make_memory_entry %lx\n",size);
    
    return org_mach_make_memory_entry(
        target_task,
        size,
        offset,
        permission,
        object_handle,
        parent_entry
                                      );
}

id _Nullable
(* org_objc_msgSend)(id _Nullable self, SEL _Nonnull op, ...);

id _Nullable
 new_objc_msgSend(id _Nullable tmp, SEL _Nonnull op, ...){
     printf("hhhhhh %p\n",tmp);
 //这个方法不行，因为objc_msgSend需要走到汇编层去重写，关键是 ... 这3个点可变参数，详情请查看
     /*
      http://ashbass.cn/2019/06/01/%E6%8A%80%E6%9C%AF/hook%20ojbc_msgSend%20%E5%87%BD%E6%95%B0%E7%BB%9F%E8%AE%A1%E6%96%B9%E6%B3%95%E6%97%B6%E9%97%B4/
      
      */
   
     return nil;
   
    
}


__attribute__((constructor)) void __main() {

    struct rebinding rebind = {};
     rebind.name = "vm_allocate";
     rebind.replacement = (void *)new_vm_allocate;
     rebind.replaced = (void **)&org_vm_allocate;
     
     struct rebinding rebind1 = {};
     rebind1.name = "vm_map";
     rebind1.replacement = (void *)new_vm_map;
     rebind1.replaced = (void **)&org_vm_map;
     
     struct rebinding rebind2 = {};
     rebind2.name = "vm_map_enter";
     rebind2.replacement = (void *)new_vm_map_enter;
     rebind2.replaced = (void **)&org_vm_map_enter;
   
     struct rebinding rebind3 = {};
     rebind3.name = "mach_msg";
     rebind3.replacement = (void *)new_mach_msg;
     rebind3.replaced = (void **)&org_mach_msg;
     
 
    
      
     //将上面的结构体 放入 reb结构体数组中
     struct rebinding red[]  = {rebind,rebind1,rebind2,rebind3};
     rebind_symbols(red, 4);
}

