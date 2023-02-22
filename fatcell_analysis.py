# -*- coding: utf-8 -*-
"""
Created on Wed Nov 16 15:29:32 2022

@author: Ania
"""

# IMPORTS
import numpy as np 
import pandas as pd 
import glob
import matplotlib.pyplot as plt
import cv2,sys
from tqdm import tqdm
from scipy.spatial import Delaunay, delaunay_plot_2d, Voronoi, voronoi_plot_2d
#%% FUNCTIONS FROM REPOSITORY (WITH SOME CHANGES):
    # https://github.com/abebe9849/Crohn_wsi 
def water_shed(gray_img,color_img,p=0.1):
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
    sure_bg = cv2.dilate(gray_img, kernel, iterations=2)## はいぱら
    dist = cv2.distanceTransform(gray_img, cv2.DIST_L2, 5)
    ret, sure_fg = cv2.threshold(dist, p * dist.max(), 255, cv2.THRESH_BINARY)
    sure_fg = sure_fg.astype(np.uint8)
    unknown = cv2.subtract(sure_bg, sure_fg)
    n_labels, markers = cv2.connectedComponents(sure_fg)
    markers += 1
    markers[unknown == 255] = 0
    markers = cv2.watershed(color_img, markers)
    return markers

def img_and(mask,canny):  # uint8 ndarray0~255
    canny = (255-canny)/255
    mask = mask/255
    new_img = np.logical_and(canny,mask)
    return new_img

def each_cell_vori(markers,thresh=0.03,plot=True):
    u, counts = np.unique(markers.ravel(), return_counts=True)
    areas = []
    emp = np.zeros_like(markers)
    margin_num = 0
    points = []
    ellipses  = []
    ellipses_rate = []
    emp_2 = np.zeros_like(markers)
    
    for cls,s in zip(u,counts):
        if cls<0:      
            tmp_img = (markers == cls)

            continue#枠(-1)
        if s<500:continue
        if s >1024*1024*thresh:
            if plot:
                tmp_img = (markers == cls)
   
            margin_num+=1
            continue
        tmp_img = (markers == cls)
        emp[np.where(markers == cls)]=cls
        emp_2[np.where(markers == cls)]=cls
        mu = cv2.moments(emp_2.astype("uint8"), False)
        try:
            x,y= int(mu["m10"]/mu["m00"]) , int(mu["m01"]/mu["m00"])
            points.append([x,y])
        except Exception as e:
            print("center not...")
            x,y = (0,0)
            points.append([x,y])
        
        contours, hierarchy = cv2.findContours(emp_2.astype("uint8"),cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        
        mx_area = 0
        for cont in contours:      
            x_,y_,w,h = cv2.boundingRect(cont)
            area = w*h     
            if area > mx_area:
                mx_area = area
                if area<10 or len(cont)<5:continue
                try:
                    ellipse = cv2.fitEllipse(cont)
                except Exception as e:
                    print(len(cont))

        try:
            ellipses.append([ellipse[1][0],ellipse[1][1]])
            ellipses_rate.append(ellipse[1][0]/ellipse[1][1])##h/w
        except Exception as e:
            print(e)    
        emp_2 = cv2.circle(emp_2, (x,y), 4, 100, 2, 4)
        emp_2[np.where(markers == cls)]=0
        
        if cls%200==0 and plot:
            plt.title(f"class{cls} area{s}")
            plt.imshow(tmp_img)
            plt.show()
        areas.append(s)
    back_area = counts[2]

    for xy in  points:
        x = xy[0]
        y =xy[1]        
        emp = cv2.circle(emp, (x,y), 4, 100, 2, 4)

    norms = []
    try:
        tri = Delaunay(points)
        tri_points = tri.points
        
        for i in range(len(tri_points)):
            for j in range(i,len(tri_points)):
                if i==j:continue
                x_i = tri_points[i][0]
                y_i = tri_points[i][1]
                x_j = tri_points[j][0]
                y_j = tri_points[j][1]
                nolm = ((x_i-x_j)**2+(y_i-y_j)**2)**0.5
                norms.append(nolm)
    except Exception as e:
        plt.imshow(emp)
        plt.savefig("error.png")
        plt.imshow(markers)
        plt.savefig("error1.png")
    return emp,areas,back_area,margin_num,norms,ellipses_rate

def margin_to_black_plus(markers,color_img,gray_img,distant=None,p=0.1,thresh = 0.03,thresh_margin=0.05,plot=False):
    u, counts = np.unique(markers.ravel(), return_counts=True)
    points = []##ボロノイ分割よう
    ellipses  = []
    ellipses_rate = []
    emp_2 = np.zeros_like(markers)

    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
    sure_bg = cv2.dilate(gray_img, kernel, iterations=2)## はいぱら
    if distant is None:
        
        dist = cv2.distanceTransform(gray_img, cv2.DIST_L2, 5)
        ret, sure_fg = cv2.threshold(dist, p * dist.max(), 255, cv2.THRESH_BINARY)
    else:
        dist = cv2.distanceTransform(distant, cv2.DIST_L2, 5)
        ret, sure_fg = cv2.threshold(dist, p * dist.max()*0.05, 255, cv2.THRESH_BINARY)
   
    sure_fg = sure_fg.astype(np.uint8)  
    unknown = cv2.subtract(sure_bg, sure_fg)
    n_labels, markers = cv2.connectedComponents(sure_fg)    
    markers += 1
    markers[unknown == 255] = 0
    markers = cv2.watershed(color_img, markers)
    
    u, counts = np.unique(markers.ravel(), return_counts=True)
    areas = []
    emp = np.zeros_like(markers)
    margin_num = 0
    for cls,s in zip(u,counts):
        if cls<0:          
            continue
        if s<500:continue
        if s >1024*1024*thresh:
            margin_num+=1
            if plot:
                tmp_img = (markers == cls)
                plt.title(f"class{cls} area{s}")
                plt.imshow(tmp_img)
                plt.show()
            continue
        tmp_img = (markers == cls)
        emp[np.where(markers == cls)]=cls
        emp_2[np.where(markers == cls)]=cls
        mu = cv2.moments(emp_2.astype("uint8"), False)

        try:
            x,y= int(mu["m10"]/mu["m00"]) , int(mu["m01"]/mu["m00"])
            points.append([x,y])
        except Exception as e:
            print("center not...")
            x,y = (0,0)
            points.append([x,y])
        
        contours, hierarchy = cv2.findContours(emp_2.astype("uint8"),cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)        
        mx_area = 0
        for cont in contours:           
            x_,y_,w,h = cv2.boundingRect(cont)
            area = w*h        
            if area > mx_area:
                mx_area = area
                if area<10 or len(cont)<5:continue
                ellipse = cv2.fitEllipse(cont)           
        try:
            ellipses.append([ellipse[1][0],ellipse[1][1]])
        except Exception as e:
            plt.imshow(color_img)
            plt.savefig("error2.png")
            plt.imshow(emp)
            plt.savefig("error.png")
            plt.imshow(gray_img)
            plt.savefig("error3.png")
            sys.exit()
        
        ellipses_rate.append(ellipse[1][0]/ellipse[1][1])##h/w        
        emp_2 = cv2.circle(emp_2, (x,y), 4, 100, 2, 4)
        emp_2[np.where(markers == cls)]=0
        
        if cls%200==0 and plot:
            plt.title(f"class{cls} area{s}")
            plt.imshow(tmp_img)
            plt.show()
        areas.append(s)
    back_area = counts[2]
    
    for xy in  points:
        x = xy[0]
        y =xy[1]        
        emp = cv2.circle(emp, (x,y), 4, 100, 2, 4)
    norms = []

    try:
        tri = Delaunay(points)
        tri_points = tri.points
        for i in range(len(tri_points)):
            for j in range(i,len(tri_points)):
                if i==j:continue
                x_i = tri_points[i][0]
                y_i = tri_points[i][1]
                x_j = tri_points[j][0]
                y_j = tri_points[j][1]
                nolm = ((x_i-x_j)**2+(y_i-y_j)**2)**0.5
                norms.append(nolm)
    except Exception as e:
        print(len(areas))
    return emp,areas,back_area,margin_num,norms,ellipses_rate

def calc_analyze_plus(path,label,num):
    areas_ = []
    backgrounds = []
    distants = []
    ellipses_rates = []
    for idx in tqdm(range(num)):
        if label==0:
            img = img =cv2.imread(path)
        else:
            img = img =cv2.imread(path)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) 
        retval, mask = cv2.threshold(gray, thresh=gray.mean(0).mean(0), maxval=255, type=cv2.THRESH_BINARY)
        markers = water_shed(mask,img)
        new_markers,areas,back_area,margin_num,norms,ellipses_rate = each_cell_vori(markers,plot=False)
        if len(areas)<20:
            gray_3 = cv2.Canny(gray,0,30)
            kernel_size = (5,5)
            kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, kernel_size)
            dilation = cv2.dilate(gray_3,kernel,iterations = 1)
            dilation = 255-dilation
            gray_3 = img_and(mask,gray_3)
            gray_3 = (gray_3*255).astype("uint8")
            gray_color = cv2.cvtColor(gray_3,cv2.COLOR_GRAY2RGB)
            new_markers_2,areas_new,back_area_new,margin_num_new,norms_new,ellipses_rate_new  = margin_to_black_plus(markers,img,mask,distant=dilation,p=0.1,thresh = 0.03,thresh_margin=0.05,plot=False)            
        
        if len(areas)<20 and len(areas)>0:
            areas_.append(areas_new)
            distants.append(norms_new)
            ellipses_rates.append(ellipses_rate_new)
            backgrounds.append(back_area)
        elif len(areas)>=20:
            areas_.append(areas)
            distants.append(norms)
            ellipses_rates.append(ellipses_rate)
            backgrounds.append(back_area)
    return areas_,backgrounds,distants,ellipses_rates
#%% GET PATEINT NAMES FROM GIVEN DATA 
def get_patient_name(path_to_file):
    path_to_file=path_to_file.rsplit('.', 1)[0]
    path_to_file=path_to_file.rsplit('\\', 1)[1]
    path_to_file=path_to_file.rsplit('_', 1)[0]
    res_path =  path_to_file
    return res_path
    
#%% EXAMPLE
test_img_path = '../004_1.tif' # path to test image
test_res = calc_analyze_plus(test_img_path,0,1)

t_areas = test_res[0][0]
num_cells = len(test_res[0][0])
print("NUMBER OF CELLS:")
print(num_cells)
#%% MORE DATA
batch_1 = glob.glob("D:/FAT_CELLS/Batch1*/*")
batch_2 = glob.glob("D:/FAT_CELLS/Batch2*/*")

pac_means = pd.DataFrame(columns=['patient_name','areas','background','distants','flatness'])

all_areas_med = []
all_bckgrnd_med = []
all_dist_med = []
all_flt_med = []
all_names = []

patient_names = []

for path in batch_2:
    print(path)
    name = get_patient_name(path)
    all_names.append(name)
        
    test_res = calc_analyze_plus(path,0,1)
    if len(all_names)>2 and name == all_names[-2]:
        print(name)
        
        all_areas_med[-1].append(test_res[0][0])
        all_bckgrnd_med[-1].append(test_res[1])
        all_dist_med[-1].append(test_res[2][0])
        all_flt_med[-1].append(test_res[3][0])  
        
    else:
        patient_names.append(name)
        all_areas_med.append(test_res[0][0])
        all_bckgrnd_med.append(test_res[1])
        all_dist_med.append(test_res[2][0])
        all_flt_med.append(test_res[3][0]) 
    
#%% FOR ALL DATA
pac_means['patient_name'] = patient_names
pac_means['areas'] = all_areas_med
pac_means['background'] = all_bckgrnd_med
pac_means['distants'] = all_dist_med
pac_means['flatness'] = all_flt_med
    
#%% EXPORT TO EXEL FORMAT
pac_means.to_excel("batch_2_data_from_patients.xlsx") 
    
    


